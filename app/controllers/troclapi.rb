# frozen_string_literal: true

require 'logger'
require 'sinatra/custom_logger'
require 'trocla'
require 'redis-store'
require 'redis-rack'
require './app/helpers/troclapi'

#
# This class run the troclapi
#
class Troclapi < Sinatra::Base
  conf = (Trocla.new(ENV['TROCLARC_FILE']).config['api'] || '')

  raise 'Troclapi config is not found' if conf.empty?

  set :troclapi, conf
  set :root, File.dirname(__FILE__)
  set :cookie_options, expires: Time.now + 3600
  set :protection, except: :path_traversal
  set :default_content_type, :json

  # Logging
  helpers Sinatra::CustomLogger
  enable :logging

  logger = Logger.new($stdout, **(settings.troclapi['logger'] || {}))
  set :logger, logger

  if conf['redis']
    use Rack::Session::Redis, conf['redis']
  else
    enable :sessions
  end

  if !settings.troclapi['token'] && !settings.troclapi['ldap']
    raise 'Troclapi configuration need token or ldap auth. Please see README'
  end

  (settings.troclapi['setting'] || {}).each do |k, v|
    set k.to_sym, v
  end

  helpers TroclapiHelpers
end
