class Request < ActiveRecord::Base
  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :lat,
                   :lng_column_name => :long
  belongs_to :project
  belongs_to :member_in_charge, foreign_key: :member_in_charge_id, class_name: :Manager
  has_many :request_statuses
  has_and_belongs_to_many :helpers, join_table: :request_statuses

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

  # State machine
  include AASM
  aasm :column => :state do
    # A request is in the `pending` state until the `start` time
    state :pending, initial: true
    # A request is in the `searching_helpers` state as long as there
    # are not enough helpers found and the time is < `end` time
    state :searching_helpers
    # A request finished successful when enough helpers where found in
    # the given time frame
    state :success
    # A request failed when there were not enough helper that
    # responded positively
    state :failed, before_enter: :timeout_helpers!

    event :start_searching do
      transitions from: :pending, to: :searching_helpers
    end
    event :successfully_found do
      transitions from: :searching_helpers, to: :success
    end
    event :failed_to_find do
      transitions from: :searching_helpers, to: :failed
    end
    event :cancel do
      transitions from: [:pending, :searching_helpers], to: :failed
    end
  end

  private

  def timeout_helpers!
    ActiveRecord::Base.transaction do
      request_statuses.each do |status|
        status.timeout = true
        status.save
      end
    end
  end
end
