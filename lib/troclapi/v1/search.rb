module Sinatra
  module Troclapi
    module V1
      module Search
        def self.registered(app)
          app.post '/v1/search/' do
            data = read_json()
            keys = (data.delete('keys') || [])
            logger.debug "Search trocla key with json value #{keys.to_s}"
            result = {}
            keys.each do |k|
              result[k] = trocla_search(k)
            end
            return result.to_json
          end
        end
      end
    end
  end
end
