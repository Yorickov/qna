module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def update_vote_up(vote_author)
    return if already_voted?(vote_author) || votable_author?(vote_author)

    transaction do
      votes.create!(user: vote_author, value: 1)
      self.rating += 1
      save!
    end
  end

  def update_vote_down(vote_author)
    return if already_voted?(vote_author) || votable_author?(vote_author)

    transaction do
      votes.create!(user: vote_author, value: -1)
      self.rating -= 1
      save!
    end
  end

  private

  def already_voted?(vote_author)
    votes.exists?(user: vote_author)
  end

  def votable_author?(vote_author)
    user == vote_author
  end
end
