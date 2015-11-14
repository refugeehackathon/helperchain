class Request < ActiveRecord::Base
  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :lat,
                   :lng_column_name => :long
  belongs_to :organization
  belongs_to :member_in_charge, foreign_key: :member_in_charge_id, class_name: :OrgaMember
  has_many :request_statuses
  has_and_belongs_to_many :helpers, join_table: :request_statuses

  validates :member_in_charge_id, :organization_id, :name, :description, :lat, :long, :amount, :timeout, :location, :range, presence: true
  validates :lat, :long, :amount, :timeout, numericality: true

  def timeout_time
    timeout.minutes
  end

  def last_deadline_from t
    t - timeout_time
  end

  def next_deadline_from t
    t + timeout_time
  end

  def confirmed_helpers
    self.helpers.where {request_statuses.accepted == true}
  end

  def pending_helpers
    self.helpers.where {(request_statuses.accepted == nil) & (request_statuses.timeout == false)}
  end

  def next_helpers
    Helper.within(range, origin: self).where { (id << my{self.helpers}) & (validated == true) }.order('random()')
  end
end
