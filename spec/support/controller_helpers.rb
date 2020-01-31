module ControllerHelpers
  def login(user)
    save_before_login(user)

    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def save_before_login(user)
    user.confirmed_at = Time.now
    user.save!
  end
end
