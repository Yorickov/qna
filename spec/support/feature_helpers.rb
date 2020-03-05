module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path

    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: user.email
      fill_in t('activerecord.attributes.user.password'), with: user.password
      click_on t('devise.shared.links.sign_in')
    end
  end

  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      'provider' => provider,
      'uid' => '123456',
      'info' => {
        'email' => email
      }
    )
  end

  def clean_mock_auth
    OmniAuth.config.mock_auth[:github] = nil
  end
end
