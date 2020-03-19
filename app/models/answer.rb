class Answer < ApplicationRecord
  include Linkable
  include Votable

  belongs_to :question
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question }, if: :best?

  after_create_commit :notify

  def set_best!
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer&.update!(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

  def to_s
    body
  end

  private

  def notify
    NotificationJob.perform_later(self)
  end
end
