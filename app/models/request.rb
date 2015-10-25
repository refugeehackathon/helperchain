class Request < ActiveRecord::Base
  belongs_to :organization
  has_many :request_statuses
  has_and_belongs_to_many :helpers, join_table: :request_statuses

  def confirmed_helpers
    return self.helpers.where {request_statuses.accepted == true}
  end

  def pending_helpers
    return self.helpers.where {(request_statuses.accepted == false) & (request_statuses.timeout == false)}
  end

  def need_to_invite_more_helpers?
    return self.pending_helpers.length + self.confirmed_helpers.length < self.amount
  end

  # Invites helpers until maximum amount is reached
  def invite_helpers
    invited = 0
    while self.invite_helper
      invited += 1
    end
    return invited
  end

  # Invites a new helper if one exists and is needed
  def invite_helper
    ActiveRecord::Base.transaction do
      if need_to_invite_more_helpers?
        helper = next_helper
        # There are still helpers that can be invited
        if helper != nil
          rs = RequestStatus.new()
          rs.helper = helper
          rs.request = self
          rs.save
          # TODO: Sent Mail to helper
          # Add Timeout to Mail response
          RequestWorker.perform_in((5+Random.rand(1.0)).seconds, rs.id)
          return true
        end
      else
        return false
      end
    end
  end

  def next_helper()
    r = self.helpers # because self doesn't work in squeel
    helpers = Helper.where{id << r}
    best_helper = helpers.max { |a, b| self.score_for(a) <=> self.score_for(b)}
    return best_helper
  end

  def score_for(helper)
    w_loc = 0.3
    w_score = 0.7
    score = w_score * helper.score + w_loc * distance_to(helper)
    return score
  end

  def distance_to(helper)
    sqrt_dist = (helper.lat-self.lat)**2 + (helper.long-self.long)**2
    return Math.sqrt(sqrt_dist)
  end

end
