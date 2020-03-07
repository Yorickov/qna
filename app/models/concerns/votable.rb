module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(vote_author)
    return false if voted?(vote_author)

    transaction do
      votes.create!(user: vote_author, value: 1)
      self.rating += 1
      save!
    end
  end

  def vote_down!(vote_author)
    return false if voted?(vote_author)

    transaction do
      votes.create!(user: vote_author, value: -1)
      self.rating -= 1
      save!
    end
  end

  def vote_reset!(vote_author)
    vote = votes.find_by(user: vote_author)
    return false unless vote

    transaction do
      vote.destroy
      self.rating -= vote.value
      save!
    end
  end

  def voted?(vote_author)
    votes.exists?(user: vote_author)
  end
end
