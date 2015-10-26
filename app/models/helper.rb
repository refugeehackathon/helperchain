class Helper < ActiveRecord::Base
  has_many :request_statuses
  has_and_belongs_to_many :requests, join_table: :request_statuses

  validates :email, :location, :lat, :long,  presence: true
  validates_format_of :email, :with => /@/
  validates :email, uniqueness: true


  def accept(request)
    # TODO: Should we test if the helper was invited for the request?
    # Decrease helper score
    self.score = score / 0.5
    self.save
    # Update RequestState
    helper = self
    rs = RequestStatus.where {(request_id == request.id) & (helper_id == helper.id)}.first
    rs.accepted = true
    rs.save
  end

  def reject(request)
    # Set helper status on request
    helper = self
    rs = RequestStatus.where {(request_id == request.id) & (helper_id == helper.id)}.first
    rs.accepted = false
    rs.save
  end
end
