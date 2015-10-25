class Request < ActiveRecord::Base
  has_many :request_statuses
  has_and_belongs_to_many :helpers, join_table: :request_statuses
  belongs_to :organization


  def next_user()
    r = self.helpers # because self doesn't work in squeel
    helpers = Helper.where{id << r}
    best_helper = helpers.max { |a, b| self.score_for(a) <=> self.score_for(b)}
    return best_helper
  end

  def score_for(user)
    w_loc = 0.3
    w_score = 0.7
    score = w_score * user.score + w_loc * distance_to(user)
    return score
  end

  def distance_to(user)
    return Math.sqrt(user.lat-self.lat)**2 + (user.long-self.long)**2
  end

end
