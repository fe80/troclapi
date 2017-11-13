require 'troclapi/helpers/login'
class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Login::Helpers

  post '/login' do
    data = read_json()

    token = (data.delete('token') || '')
    username = (data.delete('username') || '')
    password = (data.delete('password') || '')

    error(400, 'Missing token or username/passsword authentification. Please see documenation') if token.empty? && (username.empty? || password.empty?)

    unless settings.troclapi['ldap'].nil? || (username.empty? || password.empty?)
      auth = settings.troclapi['ldap']
      begin
        return { :success => true }.to_json if ldap?(auth, username, password)
      rescue => e
        rescue_return(e)
      end
    end

    t = token.empty? ? nil : check_token(token)
    logger.debug t unless t.nil?
    if !t.nil? && session[:user].nil?
      logger.debug 'Connexion succes with ' + t.to_s + ' token'
      session[:user] = t
      return { :success => true }.to_json
    elsif session[:user].nil?
      logger.debug 'Bad or missing token: ' + t unless t.nil?
    end
    error(401, 'Bad authentification')
  end
end
