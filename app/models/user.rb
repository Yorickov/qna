class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :recoverable

  has_many :questions
  has_many :answers

  def author_of?(resource)
    resource.user_id == id
  end

  def to_s
    email
  end
end
