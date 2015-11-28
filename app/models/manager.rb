class Manager < ActiveRecord::Base
  has_many :requests, foreign_key: :manager_in_charge_id
  belongs_to :project
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  belongs_to :project

  def display_name
    if name.nil? || name.empty?
      email
    else
      name
    end
  end

  rails_admin do
    object_label_method { :display_name }
    list do
      field :email
      field :project
      field :created_at
    end
  end
end
