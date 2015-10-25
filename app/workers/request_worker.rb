class RequestWorker
  include Sidekiq::Worker
  def perform(request_status_id)
    # get RequestStatuses that are not accepted and timed out
    rs = RequestStatus.where {id == request_status_id}.first
    if rs.accepted == false && rs.timeout == false
      rs.timeout = true
      rs.save
      # Invite new helper for request
      rs.request.invite_helper
    end
  end
end
