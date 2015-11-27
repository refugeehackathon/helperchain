class Project < ActiveRecord::Base
  has_many :managers
  has_many :requests
  has_many :helpers
  before_validation :slugify
  include FriendlyId
  friendly_id :slug

  def admins
    managers.where { is_admin == true }
  end

  private
  def slugify
     if self.slug.nil?
       self.slug = self.name.parameterize
     end
  end
end
