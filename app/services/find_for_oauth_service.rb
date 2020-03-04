class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)
    user ||= create_user(email)

    user.authorizations.create(provider: auth.provider, uid: auth.uid)

    user
  end

  private

  def create_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    user.skip_confirmation!
    user.save!
    user
  end
end
