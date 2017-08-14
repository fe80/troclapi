module Sinatra
  module Troclapi
    module V1
      module Set
        def self.registered(app)
          app.post '/v1/set/' do
            data = read_json()
            keys = data.delete('keys')
            default_format = (data.delete('format') || 'plain')

            keys.each do |k|
              trocla_key = (k.delete('key') || '')
              format = (k.delete('format') || default_format)
              value = (k.delete('value') || '')

              if format?(format)
                _hash = trocla_set(trocla_key, format, value)
              else
                logger.debug "Bad format #{format} for key #{trocla_key}"
                _hash = {'error' => 'Bad format', 'success' => false}
              end

              result << _hash
            end unless keys.nil?

            result.to_json
          end

          app.put '/v1/key/:trocla_key/:trocla_format' do
            format = params.delete(:trocla_format)
            trocla_key = params.delete(:trocla_key)
            data = read_json()
            value = (data.delete('value') || '')

            if format?(format)
              return trocla_set(trocla_key, format, value).to_json
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
