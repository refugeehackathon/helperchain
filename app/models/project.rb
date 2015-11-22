class Project < ActiveRecord::Base
  has_many :managers
  has_many :requests
end
