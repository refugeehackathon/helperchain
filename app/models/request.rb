class Request < ActiveRecord::Base
  belongs_to :project
  belongs_to :manager_in_charge, foreign_key: :manager_in_charge_id, class_name: :Manager
  has_many :request_statuses
  has_and_belongs_to_many :helpers, join_table: :request_statuses

  TIMEOUT_DIVIDER = 10.0
  MINIMUM_TIMEOUT = 5

  rails_admin do
    list do
      field :project
      field :name
      field :state
      field :description
      field :amount
      field :end
      field :manager_in_charge
    end
  end

  def timeout_time
    total_runtime = ((self.end - self.start).to_i / 60)
    timeout = (total_runtime / TIMEOUT_DIVIDER).to_i
    [timeout, MINIMUM_TIMEOUT].max
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
    Helper.where { (id << my{self.helpers}) & (validated == true) }.order('random()')
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
