class GistService
  ACCESS_TOKEN = ENV['GITHUB_TOKEN']
  GIST_CONTENT_NODE = 'div'.freeze

  attr_reader :url
  attr_accessor :response

  def initialize(url, client = Faraday.new)
    @url = url
    @client = client
  end

  def call
    self.response = gist_request
    response.status == 200 ? parse_content : false
  end

  private

  def gist_request
    @client.get("#{url}.json") do |request|
      request.headers['Authorization'] = "token #{ACCESS_TOKEN}"
      request.headers['Accept'] = 'application/json'
    end
  end

  def parse_content
    ActiveSupport::JSON.decode(response.body)[GIST_CONTENT_NODE]
  end
end
