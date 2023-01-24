# frozen_string_literal: true

require './app/helpers/search'

#
# This class manage search api endpoint
#
class Troclapi < Sinatra::Base
  helpers SearchHelpers

  # @deprecated
  post '/v1/search/' do
    result = {}

    (playload['keys'] || []).each do |k|
      result[k] = search(k)
    end

    result.to_json
  end

  # Search trocla key
  #
  # @yieldparam [String] key Trocla key to use (can be a ruby regex)
  # @return Hash
  #   * success (Boolean)
  #   * keys (Array)
  #
  # @see https://rubular.com/
  # @see SearchHelpers#search
  get '/v1/search/:key' do
    logger.debug format('Search actions with key %s', params['key'])

    result = search(params['key'])
    error(404, result[:error]) unless result[:success]
    result.to_json
  end
end
