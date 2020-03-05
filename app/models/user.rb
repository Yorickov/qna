class User < ApplicationRecord
  # Available are: :lockable, :timeoutable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :recoverable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions
  has_many :answers
  has_many :awards
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def to_s
    email
  end
end
