class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Search::Helpers

  post '/v2/search/' do
    data = read_json()
    keys = data.delete('keys')
    logger.debug "Search trocla key with json value #{keys.to_s}"
    result = []
    keys?(keys)
    keys.each do |k|
      result << trocla_search(k)
    end
    result.to_json
  end
end
