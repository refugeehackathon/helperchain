class RequestStatus < ActiveRecord::Base
  belongs_to :request
  belongs_to :helper

end
