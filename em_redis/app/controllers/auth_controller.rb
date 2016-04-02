class Auth < EMWSFW::ControllerBase

  def initialize(data,ws,mw)
    super
    @app_id='4587017'
    @secret='B1zWJGoOpGjyZzDV2DaB'
    @app_site='https://oauth.vk.com/authorize'
    @redir_path='http://wlad.ru:3030/#/AuthCB/'
  end

  def getAuthURI
    init_provider
    {
        :vk => @session[:oauth_provider][:vk].auth_code.authorize_url(:redirect_uri => @redir_path)
    }
  end

  private
  def init_provider
    @session[:oauth_provider][:vk]||=OAuth2::Client.new(@app_id, @secret, :site => @app_site)
  end

end

=begin
require 'oauth2'
client = OAuth2::Client.new('client_id', 'client_secret', :site => 'https://example.org')

client.auth_code.authorize_url(:redirect_uri => 'http://localhost:8080/oauth2/callback')
# => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"

token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:8080/oauth2/callback', :headers => {'Authorization' => 'Basic some_password'})
response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
response.class.name
# => OAuth2::Response
=end