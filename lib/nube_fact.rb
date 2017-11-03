require 'uri'
require 'net/http'
require 'openssl'
require 'json'

# https://docs.google.com/document/d/1QWWSILBbjd4MDkJl7vCkL2RZvkPh0IC7Wa67BvoYIhA/edit

module NubeFact; end

require "util/validator"
require "util/utils"
require "util/sunat"

require "nube_fact/version"
require "nube_fact/exceptions"

require "nube_fact/document"
require 'nube_fact/document/guia'
require 'nube_fact/document/item'
require "nube_fact/invoice"
require "nube_fact/credit_note"

module NubeFact
  API_BASE = 'https://www.nubefact.com/api/v1'
  API_BASE_DEMO = 'https://demo.nubefact.com/api/v1'

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
    base_url = @use_demo ? API_BASE_DEMO : API_BASE
    URI("#{base_url}/#{url_token}")
  end

  def use_demo!
    @use_demo = true
  end
end
