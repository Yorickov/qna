class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validate :validate_best_max_count

  def update_and_get_current_best!
    best_answer = question.answers.find_by(best: true)
    best_answer&.update(best: false)

    update(best: true)

    best_answer
  end

  private

  # rubocop:disable Style/GuardClause
  def validate_best_max_count
    if best && question.answers.where.not(id: id).exists?(best: true)
      errors.add(:best, 'errors.answers_count')
    end
  end
end
