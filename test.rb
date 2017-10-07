$: << Dir.pwd + '/lib'
require 'pry'
require 'nube_fact'

NubeFact.url_token = '8bcf167e-ecfc-4496-ac6e-8add6940e238'
NubeFact.api_token = '5046652b15ff41f9817f036b23182e789d5a04f28ca14255822a59bfcee00e4e'

puts "list"