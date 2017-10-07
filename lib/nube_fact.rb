require "nube_fact/version"
require "nube_fact/connector"
require "nube_fact/company"

module NubeFact
  API_BASE_DEMO = 'https://demo.nubefact.com/api/v1'
  API_BASE_PROD = 'https://www.nubefact.com/api/v1'

  READ_TIMEOUT = 120
  LIST_TIMEOUT = 360

  class << self
      attr_accessor :url_token
      attr_accessor :api_token
  end
end
