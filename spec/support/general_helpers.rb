module GeneralHelpers
  def gist_stub_request(url, status, expected_content = nil)
    stubbed_response_body = expected_content ? { div: expected_content }.to_json : ''
    gist_request("#{url}.json", status, stubbed_response_body)
  end

  def auth_hash(provider, email = nil)
    OmniAuth::AuthHash.new(
      'provider' => provider,
      'uid' => '123456',
      'info' => {
        'email' => email
      }
    )
  end

  private

  def gist_request(uri, status, body = '')
    stub_request(:get, uri)
      .with(
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => "token #{ENV['GITHUB_TOKEN']}",
          'User-Agent' => 'Faraday v1.0.1'
        }
      )
      .to_return(status: status, body: body, headers: {})
  end
end
