class Project < ActiveRecord::Base
  has_many :managers
  has_many :requests
  before_validation :slugify
  include FriendlyId
  friendly_id :slug

  private
  def slugify
     if self.slug.nil?
       self.slug = self.name.parameterize
     end
  end
end
