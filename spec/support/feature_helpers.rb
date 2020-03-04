module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path

    within('#new_user') do
      fill_in t('activerecord.attributes.user.email'), with: user.email
      fill_in t('activerecord.attributes.user.password'), with: user.password
      click_on t('devise.shared.links.sign_in')
    end
  end

  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'github',
      'uid' => '123456',
      'info' => {
        'email' => 'some@email.com'
      }
    )
  end

  def clean_mock_auth
    OmniAuth.config.mock_auth[:github] = nil
  end
end
