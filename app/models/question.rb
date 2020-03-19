class Question < ApplicationRecord
  include Linkable
  include Votable

  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_one :award, dependent: :destroy
  belongs_to :user

  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  has_many_attached :files
  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  scope :last_day_created, -> { where(created_at: Time.zone.yesterday.all_day) }

  after_create :subscribe_author!

  def to_s
    "#{title} #{body}"
  end

  private

  def subscribe_author!
    subscribed_users << user
  end
end
