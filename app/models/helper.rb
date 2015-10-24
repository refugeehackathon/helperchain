class Helper < ActiveRecord::Base
  has_many :request_statuses
  has_and_belongs_to_many :requests, join_table: :request_statuses


  
end
