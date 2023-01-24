# frozen_string_literal: true

require './app/helpers/login'

#
# This class manage the login endpoint
#
class Troclapi < Sinatra::Base
  helpers LoginHelpers

  # Login to the private endpoint
  #
  # @yieldparam [Hash] playload
  #   * username (String)
  #   * password (String)
  post '/login' do
    if playload['token']
      auth_token(playload['token'])
      logger.info format('Connexion succes with %s token', session[:user].to_s)
    else
      logger.debug format('Ldap login for %s', playload['username'])
      auth_login(playload)
    end
    { success: true }.to_json if session[:user]
  rescue Unauthorized => e
    error(401, e.message)
  rescue StandardError => e
    rescue_return(e)
  end
end
