# frozen_string_literal: true

require './app/helpers/set'

#
# This class manage set api endpoint
#
class Troclapi < Sinatra::Base
  helpers SetHelpers

  # Set multiple trocla key with random value
  #
  # @yieldparam [Hash] playload
  #   * keys (Hash) List of key to set
  #   * format (String) Default trocla format (merge for all key)
  #   * **xarg All other parameters are dymanic trocla options (merge for all key)
  # @return [Hash]
  # @see SetHelpers#set
  #
  post '/v1/set/' do
    result = []

    (playload['keys'] || []).each do |k|
      key = k.delete('key')
      format = (k.delete('format') || playload['format'])
      value = k.delete('value')
      options = playload.merge(k)

      result << set(key, format, value, options)
    end

    result.to_json
  end

  # Set trocla key with random value
  #
  # @yieldparam [String] key Trocla key name
  # @yieldparam [String] format Trocla key format
  # @yieldparam [Hash] playload Dynamic Trocla options
  # @return [Hash]
  #   * value (String)
  #   * success (Boolean)
  #   * format (String)
  # @see SetHelpers#set
  #
  put '/v1/key/:key/:format' do
    logger.debug format('Set actions with params %s', playload.to_s)

    result = set(
      params['key'], params['format'], playload.delete('value'),
      playload
    )
    error(404, result[:error]) unless result[:success]
    result.to_json
  end
end
