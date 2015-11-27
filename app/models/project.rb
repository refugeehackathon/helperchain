class Project < ActiveRecord::Base
  has_many :managers
  has_many :requests
  has_many :helpers
  before_validation :generate_invite_key
  before_validation :slugify
  include FriendlyId
  friendly_id :slug

  def admins
    managers.where { is_admin == true }
  end

  def generate_invite_key
    if self.invite_key.nil?
      self.invite_key = SecureRandom.urlsafe_base64
    end
  end

  private

  def slugify
     if self.slug.nil?
       self.slug = self.name.parameterize
     end
  end
end
