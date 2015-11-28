class Project < ActiveRecord::Base
  has_many :managers
  has_many :requests
  has_many :helpers
  before_validation do
    generate_invite_key
    slugify
  end
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
      # Suggested by http://stackoverflow.com/questions/136793/is-there-a-do-while-loop-in-ruby
      loop do
        self.slug = "#{self.name.parameterize}-#{rand(10000)}"
        break if Project.find_by_slug(self.slug).nil?
      end
     end
  end
end
