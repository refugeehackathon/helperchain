class RequestStatus < ActiveRecord::Base
  belongs_to :request
  has_many :helpers
end
