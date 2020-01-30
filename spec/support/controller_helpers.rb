module ControllerHelpers
  def login(user)
    user.skip_confirmation!
    user.save!

    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
