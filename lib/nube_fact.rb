require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module NubeFact; end

require "util/validator"
require "util/utils"

require "nube_fact/version"
require "nube_fact/exceptions"
require "nube_fact/invoice"
require 'nube_fact/invoice/guia'
require 'nube_fact/invoice/item'

module NubeFact
  API_BASE = 'https://www.nubefact.com/api/v1'

  READ_TIMEOUT = 120
  LIST_TIMEOUT = 360

  DATE_FORMAT = "%d-%m-%Y"

  extend self
  
  attr_accessor :url_token
  attr_accessor :api_token

  def request(data)
    raise NotConfigured unless url_token && api_token

    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = READ_TIMEOUT
    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request.body = data.to_json

    request["Authorization"] = 'Token token="%s"' % api_token
    request["Content-Type"] = 'application/json'
    request["cache-control"] = 'no-cache'

    response = http.request request

    # ToDO evaluate response code (not authorized, 500, etc)

    result = JSON.parse(response.read_body)
    if result['errors']
      raise ErrorResponse.new "#{result['codigo']}: #{result['errors']}"
    end

    result
  end

  def url
    URI("#{API_BASE}/#{url_token}")
  end
end
