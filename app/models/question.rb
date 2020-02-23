class Question < ApplicationRecord
  include Linkable

  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_one :award, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def to_s
    "#{title}#{body}"
  end
end
