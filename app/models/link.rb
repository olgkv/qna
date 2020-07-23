class Link < ApplicationRecord
  URL_REGEX = %r{https?://[\S]+}.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_REGEX, message: 'URL is invalid' }

  def gist_link?
    url.include?('gist.github.com')
  end
end
