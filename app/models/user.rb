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

  has_many :questions, inverse_of: 'author'
  has_many :answers, inverse_of: 'author'

  def to_s
    email
  end
end
