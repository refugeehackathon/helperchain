class AddInviteKeyToProjects < ActiveRecord::Migration
  require 'securerandom'
  def change
    add_column :projects, :invite_key, :string
    Project.all.each do |p|
      p.invite_key = SecureRandom.urlsafe_base64
      p.save
    end
  end
end
