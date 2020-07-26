module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    votes.create(user: user, value: -1)
  end

  def amount_of_votes
    votes.sum(:value)
  end

  def votes?
    votes.any?
  end

  def vote_by_user(user)
    votes.find_by(user: user)
  end

  def votable_by?(user)
    !user.author_of?(self) && vote_by_user(user).nil?
  end
end
