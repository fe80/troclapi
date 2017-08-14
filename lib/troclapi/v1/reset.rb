module Sinatra
  module Troclapi
    module V1
      module Reset
        def self.registered(app)
          app.post '/v1/reset/' do

            data = read_json()

            result = []

            keys = data.delete('keys')
            default_format = (data.delete('format') || 'plain')
            default_options = (data.clone || {})

            keys.each do |k|
              trocla_key = (k.delete('key') || '')
              format = (k.delete('format') || default_format)
              other_options = default_options.merge(k)

              if format?(format)
                _hash = trocla_reset(trocla_key, format, other_options).merge({'key' => trocla_key})
              end

              _hash.delete('options')

              result << _hash
            end unless keys.nil?

            result.to_json

          end

          app.patch '/v1/key/:trocla_key/:trocla_format' do
            format = params.delete(:trocla_format)
            trocla_key = params.delete(:trocla_key)
            other_options = (params.clone || {})

            logger.debug "Reset actions with query_string #{other_options}"

            if format?(format)
              return trocla_reset(trocla_key, format, other_options).to_json
            else
              logger.debug "Bad format #{format} for key #{trocla_key}"
              {'error' => 'Bad format', 'success' => false}.to_json
            end
          end
        end
      end
    end
  end
end
