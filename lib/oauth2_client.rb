require 'rest-client'
require 'json'

class Oauth2Client
  def initialize client_id, client_secret, base_api_uri, base_url, username, password
    response = RestClient.post base_url + base_api_uri + '/oauth2/token',
                               {
                                 'grant_type' => 'password',
                                 'client_id' => client_id,
                                 'client_secret' => client_secret,
                                 'username' => username,
                                 'password' => password,
                                 'platform' => 'base'
                               }.to_json,
                               :content_type => :json,
                               :accept => :json
    response_obj = JSON.parse response

    @access_token = response_obj['access_token']
    @refresh_token = response_obj['refresh_token']
    @base_url = base_url
    @base_api_uri = base_api_uri
  end
  
  def post resource, params
    puts "POST to: " + @base_url + @base_api_uri + resource
    puts "Data: #{params.to_json} \n\n"
    JSON.parse(RestClient.post @base_url + @base_api_uri + resource, params.to_json,
                               :content_type => :json, :accept => :json,
                               :'OAuth-Token' => @access_token)
  end

  def get resource
    puts "GET to: " + @base_url + @base_api_uri + resource + "\n\n"
    JSON.parse(RestClient.get @base_url + @base_api_uri + resource,
                              :'OAuth-Token' => @access_token)
  end

  def put resource, params
    puts "PUT to: " + @base_url + @base_api_uri + resource + "\n\n"
    JSON.parse(RestClient.put @base_url + @base_api_uri + resource, params.to_json,
                               :content_type => :json, :accept => :json,
                               :'OAuth-Token' => @access_token)
  end

end
