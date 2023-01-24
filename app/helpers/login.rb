# frozen_string_literal: true

#
# This module contain helpers for login endpoint
#
module LoginHelpers
  # Test session
  #
  # @return [Boolean]
  def authorize?
    if request.env['HTTP_X_TOKEN']
      token?(request.env['HTTP_X_TOKEN'])
    else
      !session[:user].nil?
    end
  end

  # Test an ldap connexion
  #
  # @api private
  #
  # rubocop:disable Metrics/AbcSize
  def ldap?(auth, username, password)
    require 'net/ldap'

    raise 'Missing ldap base' unless auth[:base]

    @ldap = Net::LDAP.new auth

    raise format('Ldap connexion fail %s', ldap.inspect) unless ldap.bind

    dn = ldap_search(auth[:base], filer_strip(auth[:filter], username))
    ldap.authenticate(dn, password)
    session[:user] = username if ldap.bind
    !session[:user].nil?
  end
  # rubocop:enable Metrics/AbcSize

  #
  # @api private
  #
  def ldap
    @ldap
  end

  #
  # @api private
  #
  def ldap_search(base, filter)
    search = ldap.search(base: base, filter: filter, attributes: ['dn'])
    raise format('Ldap search return %s result', search.length) if search.length != 1

    search[0].dn
  end

  #
  # @api private
  #
  def filer_strip(filter, username)
    return nil unless filter

    filter.gsub('{username}', username)
  end

  #
  # @api private
  #
  def token?(token)
    tokens = (settings.troclapi['token'] || {})
    error(400, 'Missing tokens configuration, please see documentation') if tokens.empty?
    tokens.each do |user, to|
      if to == token
        session[:user] = user
        return true
      end
    end
    false
  end

  #
  # @api private
  #
  def auth_login(auth)
    unless auth['username'] && auth['password']
      error(
        401,
        'Missing token or username/passsword authentification.'
      )
    end
    raise Unauthorized, 'Bad authentification.' unless ldap?(
      settings.troclapi['ldap'], auth['username'], auth['password']
    )
  end

  #
  # @api private
  #
  def auth_token(token)
    raise Unauthorized, 'Token connexion fail' unless token?(token)
  end
end
