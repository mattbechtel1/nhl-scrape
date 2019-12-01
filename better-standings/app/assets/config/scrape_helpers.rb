require 'json'
require 'rest-client'

STANDINGS = 'https://statsapi.web.nhl.com/api/v1/standings'

response_string = RestClient.get(STANDINGS)
response_hash = JSON.parse(response_string)