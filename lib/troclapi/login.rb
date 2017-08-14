module Sinatra
  module Troclapi
    module Login
      module Helpers
        def ldap?(auth, username, password)
          require 'net/ldap'

          logger.debug 'Ldap conf detected ' + auth.to_s
          logger.debug 'User: ' + username.to_s
          logger.debug 'Password: ' + password.class.to_s

          base = auth.delete(:base)
          memberof = (auth.delete(:memberOf) || '')
          ldap = Net::LDAP.new auth
          if ldap.bind
            filter = unless memberof.empty?
                       "(&(sAMAccountName=#{username})(memberOf=#{memberof}))"
                     else
                       "(&(sAMAccountName=#{username}))"
                     end

            logger.debug 'ldapsearch ' + base.to_s + filter.to_s
            ldap.search( :base => base, :filter => filter, :attributes => ['dn'], :return_result => false ) do |entry|
              logger.debug 'Found user ' + entry.dn.to_s
              userauth = { :auth => { :username => entry.dn, :password => password } }
              auth[:auth] = auth[:auth].merge(userauth)
              l = Net::LDAP.new auth
              if l.bind
                logger.debug 'Login succes for ' + username
                session[:user] = username
                return true
              else
                logger.debug 'Ldap user connexion fail' + username.to_s
              end
            end
          end
        end
      end

      def self.registered(app)
        app.post '/login' do
          data = read_json()

          token = (data.delete('token') || '')
          username = (data.delete('username') || '')
          password = (data.delete('password') || '')

          unless settings.troclapi['ldap'].nil? || (username.empty? || password.empty?)
            auth = settings.troclapi['ldap']
            begin
              return { "success" => true }.to_json if ldap?(auth, username, password)
            rescue => e
              rescue_return(e)
            end
          end

          if settings.troclapi['token'] == token && session[:user].nil?
            logger.debug 'Connexion succes with token'
            session[:user] = token
            return { 'success' => true }.to_json
          elsif session[:user].nil?
            logger.debug 'Bad or missing token: ' + token + ' ' +  settings.troclapi['token']
          end
          { 'success' => false }.to_json
        end
      end
    end
  end
end
