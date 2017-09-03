require 'sinatra/base'
require 'logger'
require 'trocla'
require 'troclapi/helpers'
require 'troclapi/helpers/login'
require 'troclapi/login'
require 'troclapi/v1'
require 'troclapi/trocla' # Monkey patch for search action
require 'troclapi/version'

class Troclapi < Sinatra::Base
  conf = (Trocla.new.config['api'] || '')

  raise 'Troclapi config is not found' if conf.empty?

  set :troclapi, conf
  set :root, File.dirname(__FILE__)
  enable :sessions
  set :cookie_options, :expires => Time.now + 3600

  # Logging
  enable :logging
  configure :development do
    set :logging, Logger::DEBUG
  end

  raise 'Troclapi configuration need token or ldap auth. Please see README' if settings.troclapi['token'].nil? && settings.troclapi['ldap'].nil?

  (settings.troclapi['setting'] || {}).each do |k,v|
    set k, v
  end

  before do
    content_type :json
  end

  before '/v1/*' do
    authorize!
  end

  not_found do
    status 404
    { 'success' => false, 'error' => '404 Not found or bad method' }.to_json
  end

  helpers Sinatra::Troclapi::Login::Helpers
  helpers Sinatra::Troclapi::Helpers
end
