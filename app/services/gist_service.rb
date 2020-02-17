class GistService
  GIST_ID_FORMAT = /\w*$/.freeze

  attr_reader :url
  attr_accessor :response

  def initialize(url, client = nil)
    @url = url
    @client = client || Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end

  def call
    self.response = @client.gist(gist_id)
  rescue Octokit::NotFound
    false
  end

  def parsed_body
    response.files.to_h.values.map { |f| f[:content] }.join("\n")
  end

  private

  def gist_id
    GIST_ID_FORMAT.match(url)[0]
  end
end
