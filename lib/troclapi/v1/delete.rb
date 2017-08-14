module Sinatra
  module Troclapi
    module V1
      module Delete
        def self.registered(app)
          app.post '/v1/delete/' do

            data = read_json()
            keys = data.delete('keys')
            default_format = (data.delete('format') || 'plain')

            result = []

            keys.each do |k|
              trocla_key = (k.delete('key') || '')
              format = (k.delete('format') || default_format)

              if format?(format)
                _hash = trocla_delete(trocla_key, format).merge({'key' => trocla_key})
              else
                logger.debug "Bad format #{format} for key #{trocla_key}"
                _hash = {'error' => 'Bad format', 'success' => false}
              end

              result << _hash
            end unless keys.nil?

            result.to_json
          end

          app.delete '/v1/key/:trocla_key/:trocla_format' do
            format = params.delete(:trocla_format)
            trocla_key = params.delete(:trocla_key)

            if format?(format)
              return trocla_delete(trocla_key, format).to_json
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
