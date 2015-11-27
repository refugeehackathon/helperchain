class Helper < ActiveRecord::Base
  belongs_to :project
  has_many :request_statuses
  has_and_belongs_to_many :requests, join_table: :request_statuses
  before_validation :generate_confirmation_key

  validates_format_of :email, :with => /@/
  validates_uniqueness_of :email, :scope => :project_id

  rails_admin do
    object_label_method { :email }
    list do
      field :email
      field :project
      field :validated
      field :created_at
    end
  end

  def contact_address
    email # || phone_number # For later
  end

  def accepted_requests
    request_statuses.where {accepted == true}
  end

  private
  def generate_confirmation_key
    self.confirmation_key = SecureRandom.urlsafe_base64
  end
end
