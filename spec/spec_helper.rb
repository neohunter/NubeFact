require 'simplecov'
SimpleCov.start

require 'pry'
require 'rspec'
require 'webmock/rspec'

require 'nube_fact'


WebMock.disable_net_connect!(allow_localhost: true)