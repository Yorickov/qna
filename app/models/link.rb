class Link < ApplicationRecord
  GIST_URL_FORMAT = /^https:\/\/gist\.github\.com\/.+$/.freeze

  after_validation :update_gist, if: ->(link) { link.url =~ GIST_URL_FORMAT }

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url,
            format: { with: URI::DEFAULT_PARSER.make_regexp },
            if: ->(link) { link.url.present? }

  def update_gist
    self.body = gist_body
  end

  private

  def gist_body
    GistService.new(url).call
  end
end
