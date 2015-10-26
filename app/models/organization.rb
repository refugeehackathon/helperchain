class Organization < ActiveRecord::Base
  has_many :orga_members
  has_many :requests

  validates :name,  presence: true
end
