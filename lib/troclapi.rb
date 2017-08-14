require 'sinatra/base'
require 'logger'
require 'trocla'
require 'troclapi/helpers'
require 'troclapi/login'
require 'troclapi/v1'

class Troclapi < Sinatra::Base
  conf = (Trocla.new.config['api'] || '')

  raise 'Troclapi config is not found' if conf.empty?

  set :troclapi, conf
  set :root, File.dirname(__FILE__)
  enable :sessions

  # Logging
  enable :logging
  configure :development do
    set :logging, Logger::DEBUG
  end

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

  register Sinatra::Troclapi::Login
  helpers Sinatra::Troclapi::Login::Helpers
  helpers Sinatra::Troclapi::Helpers
end
