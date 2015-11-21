class Helper < ActiveRecord::Base
  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :lat,
                   :lng_column_name => :long
  has_many :request_statuses
  has_and_belongs_to_many :requests, join_table: :request_statuses

  validates_format_of :email, :with => /@/
  validates :email, uniqueness: true

  rails_admin do
    object_label_method { :email }
    list do
      field :email
      field :location
      field :validated
      field :created_at
    end
  end

  def contact_address
    email # || phone_number # For later
  end
end
