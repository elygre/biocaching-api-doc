# Requires: 
#  $ sudo gem install rest-client
# 



require 'rest-client'
require 'pp'

load './params.rb'

begin
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  puts JSON.parse(response)
  search_params= "size=5&from=0&user_id=1&taxon_id=61057"
  #search_params= "latitude=60&longitude=11&distance=2000km&size=5&from=0&"
  #search_params= "top_left=14.0,66.1&bottom_right=15.1,60.56&size=5&taxon_id=61057"
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  response = RestClient.get "http://#{@server}/observations?all=true&#{search_params}", @http_headers

  puts response.code
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)

  
  
  
rescue RestClient::Unauthorized => e
  puts "unauthorized, login failed."  
  
rescue  Exception => e
  puts e.message
  puts e.class.name
  exit
end
