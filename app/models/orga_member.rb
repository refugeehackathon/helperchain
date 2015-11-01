class OrgaMember < ActiveRecord::Base
  belongs_to :organization
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :organization


  rails_admin do
    object_label_method { :email }
    list do
      field :email
      field :organization
      field :created_at
    end
  end
end
