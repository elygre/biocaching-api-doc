# Requires: 
#  $ sudo gem install rest-client
# 


require 'rest-client'
require 'pp'

if ARGV.size < 3
  puts "usage:"
  puts "  ruby <script>.rb <APIHOST> <username> <password>"
  puts "  for example: ruby list_observations.rb api.biocaching.com:82 bjorn@biocaching.com password"
  puts 
  exit 1
else
  @server   = ARGV[0]
  @username = ARGV[1]
  @password = ARGV[2]
end  

@http_headers = {accept: :json, 'X-User-Api-Key' => '621f85bdc3482ec12991019729aa9315', referer: 'http://localhost'}

observation_params = {
   observation: { 
     taxon_id: 61057, 
     observed_at: Time.now.to_s, 
     latitude: 65.123, 
     longitude: 14.234, 
     picture_attributes: { 
       primary: true, 
       picture: File.new("greylag_goose.jpg", 'rb')
       }, 
     coordinate_uncertainty_in_meters: 30, 
     individual_count: 5, 
     sex: "3 males, 2 females", 
     life_stage: "4 adults, 1 juvenile"
     }, 
   multipart: true, 
   content_type: 'application/json'}

begin
  
  params = {user:{email:@username, password:@password}}
  response = RestClient.post("http://#{@server}/users/sign_in.json", params, @http_headers)
  token = JSON.parse(response)["authentication_token"]
  
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
  @http_headers.merge!({'X-User-Email' => @username, 'X-User-Token' => token})
  
  response = RestClient.post "http://#{@server}/observations", observation_params, @http_headers
  
  json = JSON.parse(response)
  puts JSON.pretty_generate(json)
  
rescue RestClient::Unauthorized => e
  puts "unauthorized...."  
  exit
rescue  Exception => e

  puts e.message
  puts e.response.code
  pp e.response
end
