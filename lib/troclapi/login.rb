class Troclapi < Sinatra::Base
  post '/login' do
    data = read_json()

    token = (data.delete('token') || '')
    username = (data.delete('username') || '')
    password = (data.delete('password') || '')

    halt 400, { :success => false, :error => 'Missing token or username/passsword authentification. Please see documenation'}.to_json if token.empty? && (username.empty? || password.empty?)

    unless settings.troclapi['ldap'].nil? || (username.empty? || password.empty?)
      auth = settings.troclapi['ldap']
      begin
        return { :success => true }.to_json if ldap?(auth, username, password)
      rescue => e
        rescue_return(e)
      end
    end

    if settings.troclapi['token'] == token && session[:user].nil?
      logger.debug 'Connexion succes with token'
      session[:user] = 'token'
      return { :success => true }.to_json
    elsif session[:user].nil?
      logger.debug 'Bad or missing token: ' + token + ' ' +  settings.troclapi['token']
    end
    { :success => false }.to_json
  end
end
