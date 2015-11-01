class RequestWorker
  include Sidekiq::Worker
  def perform(request_id)
    @request = Request.find request_id
    # Timeout helpers that need to be timeouted
    timeout_helpers
    if not need_more_helpers?
      RequestMailer.request_done(@request).deliver_later
    elsif next_batch_size > 0 # Do we need to send any mails right now?
      helpers = @request.next_helpers.limit next_batch_size
      if helpers.empty?
        RequestMailer.no_more_helpers(@request).deliver_later
      else
        helpers.each {|h| send_helper_mail(h)}
        RequestWorker.perform_in(@request.timeout_time, @request.id)
      end
    end
  end

  private

  def send_helper_mail(helper)
    rs = RequestStatus.create helper: helper, request: @request
    RequestMailer.helper_request(rs).deliver_later
  end

  def timeout_helpers
    timeout_deadline = @request.last_deadline_from Time.now
    statuses = @request.request_statuses.where { (accepted == nil) & (timeout == false) & (created_at < timeout_deadline) }
    statuses.each do |status|
      status.timeout = true
      status.save
    end
  end

  def next_batch_size
    @request.amount - @request.pending_helpers.count
  end

  def need_more_helpers?
    @request.amount > @request.request_statuses.where { accepted == true }.count
  end
end
