# frozen_string_literal: true

require './app/helpers/reset'

#
# This class maange reset api endpoint
#
class Troclapi < Sinatra::Base
  helpers ResetHelpers

  # Reset multiple trocla key with random value
  #
  # @yieldparam [Hash] playload
  #   * keys (Hash) List of key to reset
  #   * format (String) Default trocla format (merge for all key)
  #   * **xarg All other parameters are dymanic trocla options (merge for all key)
  # @return [Hash]
  # @see ResetHelpers#reset
  #
  post '/v1/reset/' do
    result = []

    (playload['keys'] || []).each do |k|
      key = k.delete('key')
      format = (k.delete('format') || playload['format'])
      options = playload.merge(k)

      result << reset(key, format, options).merge(key: key)
    end

    result.to_json
  end

  # Reset trocla key with random value
  #
  # @yieldparam [String] key Trocla key name
  # @yieldparam [String] format Trocla key format
  # @yieldparam [Hash] playload Dynamic Trocla options
  # @return [Hash]
  #   * value (String)
  #   * success (Boolean)
  #   * format (String)
  # @see ResetHelpers#reset
  #
  patch '/v1/key/:key/:format' do
    logger.debug format('Reset actions with query_string %s', playload.to_s)

    result = reset(params['key'], params['format'], playload)
    error(404, result[:error]) unless result[:success]
    result.to_json
  end
end
