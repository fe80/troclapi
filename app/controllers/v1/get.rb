# frozen_string_literal: true

require './app/helpers/get'

#
# This class manage get api endpoint
#
class Troclapi < Sinatra::Base
  helpers GetHelpers

  # Get multiple trocla key
  #
  # @yieldparam [Hash] playload
  #   * keys (Hash) List of keys to key
  #   * format (String) Default trocla format (merge for all key)
  #   * render (String) Render filter to apply (useful for x509 or sshkey)
  # @return [Hash]
  # @see GetHelpers#get
  #
  post '/v1/get/' do
    result = []

    (playload['keys'] || []).each do |k|
      key = k.delete('key')
      format = (k.delete('format') || playload['format'])
      render = (k.delete('render') || playload['render'] || nil)

      res = get(key, format, { render: render })
      res.merge!(success: false, error: 'Key not found on this format') if res[:value].nil?
      result << res.merge(key: key)
    end
    result.to_json
  end

  # Get trocla key
  #
  # @yieldparam [String] key Trocla key name
  # @yieldparam [String] format Trocla key format
  # @yieldparam [String] render Render filter to apply (useful for x509 or sshkey)
  # @return [Hash]
  #   * value (String)
  #   * success (Boolean)
  #   * format (String)
  # @see GetHelpers#get
  #
  get '/v1/key/:key/:format/?:render?' do
    result = get(params['key'], params['format'], { 'render' => params['render'] })
    error(404, result[:error]) unless result[:success]
    error(404, 'Key not found on this format') if result[:value].nil?
    result.to_json
  end
end
