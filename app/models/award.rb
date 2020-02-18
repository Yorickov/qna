class Award < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :title, presence: true
  validate :validate_image_presence

  def validate_image_presence
    errors.add(:image, 'should has attached image') unless image.attached?
  end
end
