class RequestStatus < ActiveRecord::Base
  belongs_to :request
  belongs_to :helper
  has_one :organization, through: :request

  def accept
    # Decrease helper score
    helper.score = score / 0.5
    helper.save
    # Update RequestState
    self.accepted = true
    self.save
  end

  def decline
    self.accepted = false
    self.save
  end
end
