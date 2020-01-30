module ControllerHelpers
  def login(user)
    user.confirmed_at = Time.now
    user.save!

    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
