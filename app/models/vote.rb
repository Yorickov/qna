class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :user, uniqueness: { scope: %i[votable_type votable_id] }
end
