# frozen_string_literal: true

require './app/helpers/delete'

#
# This class manage delete api endpoint
#
class Troclapi < Sinatra::Base
  helpers DeleteHelpers

  # Delete multiple trocla key with specific format
  #
  # @yieldparam [Hash] playload
  #   * keys (Hash) List of key to delete
  #   * format (String) Default trocla format (merge for all key)
  #   * **xarg All other parameters are dymanic trocla options (merge for all key)
  # @return [Hash]
  # @see DeleteHelpers#delete
  #
  post '/v1/delete/' do
    result = []

    (playload['keys'] || []).each do |k|
      key = (k.delete('key') || '')
      format = (k.delete('format') || playload['format'] || 'plain')

      del = delete(key, format)
      del.merge!(success: false, error: 'Key not found on this format') if del[:value].nil?
      result << del.merge(key: key)
    end

    result.to_json
  end

  # Delete trocla key with specific format
  #
  # @yieldparam [String] key Trocla key name
  # @yieldparam [String] format Trocla key format
  # @yieldparam [Hash] playload Dynamic Trocla options
  # @return [Hash]
  #   * value (String)
  #   * success (Boolean)
  #   * format (String)
  # @see DeleteHelpers#delete
  #
  delete '/v1/key/:key/:format' do
    result = delete(params['key'], params['format'])
    error(404, result[:error]) unless result[:success]
    error(404, 'Key not found on this format') if result[:value].nil?
    result.to_json
  end
end
