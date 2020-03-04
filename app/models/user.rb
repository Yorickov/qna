class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable,
         :registerable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :recoverable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions
  has_many :answers
  has_many :awards
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save!
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def to_s
    email
  end
end
