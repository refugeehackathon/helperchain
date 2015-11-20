# coding: utf-8
class RequestWorker
  include Sidekiq::Worker
  def perform(request_id)
    ActiveRecord::Base.transaction do
      @request = Request.find request_id
      # Timeout helpers that need to be timeouted
      timeout_helpers
      # First check in which state we are
      # If the request is pending and we can start the search, do so
      if @request.pending?
        if Time.now >= @request.start
          # Start searching
          @request.start_searching!
          handle_searching_helpers
        else
          # Delay the search start to the start time
          RequestWorker.perform_at(@request.start, @request.id)
        end
      elsif @request.searching_helpers?
        if Time.now >= @request.end
          # Cancel the search
          @request.failed_to_find!
          RequestMailer.no_more_helpers(@request).deliver_later
        else
          # Search
          handle_searching_helpers
        end
      end
    end
  end

  private

  def handle_searching_helpers
    if not need_more_helpers?
      Rails.logger.info("Request done")
      @request.successfully_found!
      RequestMailer.request_done(@request).deliver_later
    elsif next_batch_size > 0 # Do we need to send any mails right now?
      helpers = @request.next_helpers.limit next_batch_size
      if helpers.empty? and @request.pending_helpers.empty?
        # Perform the next search at the half time between now and the
        # end time or 5 minutes from now on – depending what is
        # earlier
        perform_time = [Time.now + ((@request.end - Time.now) / 2),
                        Time.now + 5.minutes].min
        RequestWorker.perform_at(perform_time, @request.id)
      else
        Rails.logger.info("Request sent")
        helpers.each {|h| send_helper_mail(h)}
        RequestWorker.perform_in(@request.timeout_time, @request.id)
      end
    end
  end

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
