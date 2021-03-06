# frozen_string_literal: true

class UrlRelation < ApplicationRecord
  validates :input_url, url: { no_local: true }, uniqueness: true

  before_validation :add_trailing_slash, on: :create

  has_many :user_requests

  def add_request_info!(request)
    return if request.blank?

    browser = Browser.new(request.user_agent)
    user_requests.create!(platform_name: browser.platform.name,
                          platform_version: browser.platform.version,
                          browser_name: browser.name,
                          browser_version: browser.version,
                          ip: request.ip)
  end

  def shortened_url_code
    @shortened_url_code ||= Utils::UrlUtils.encode(id)
  end

  def add_trailing_slash
    return unless input_url

    self.input_url = Utils::UrlUtils.with_trailing_slash(input_url)
  end
end
