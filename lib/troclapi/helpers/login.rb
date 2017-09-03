module Sinatra
  module Troclapi
    module Login
      module Helpers
        def ldap?(auth, username, password)
          require 'net/ldap'

          logger.debug 'Ldap conf detected ' + auth.to_s
          logger.debug 'User: ' + username.to_s
          logger.debug 'Password: ' + password.class.to_s

          base = (auth[:base] || '')
          raise 'Missing ldap base' if base.empty?
          filter = (auth[:filter] || '(&(sAMAccountName={username}))').gsub('{username}', username)
          ldap = Net::LDAP.new auth
          if ldap.bind
            logger.debug 'ldapsearch ' + base.to_s + filter.to_s
            ldap.search( :base => base, :filter => filter, :attributes => ['dn'], :return_result => false ) do |entry|
              logger.debug 'Found user ' + entry.dn.to_s
              u = auth.clone
              u[:auth] = auth[:auth].merge({ :username => entry.dn, :password => password })
              l = Net::LDAP.new u
              if l.bind
                logger.debug 'Login succes for ' + username
                session[:user] = username
                return true
              else
                logger.debug 'Ldap user connexion fail' + username.to_s
              end
            end
          else
            false
          end
          false
        end
      end
    end
  end
end
