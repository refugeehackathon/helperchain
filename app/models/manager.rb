class Manager < ActiveRecord::Base
  belongs_to :project
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  belongs_to :project


  rails_admin do
    object_label_method { :email }
    list do
      field :email
      field :project
      field :created_at
    end
  end
end
