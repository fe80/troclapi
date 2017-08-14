module Sinatra
  module Troclapi
    module V1
      module Create
        def self.registered(app)
          app.post '/v1/create/' do
            data = read_json()

            result = []

            keys = data.delete('keys')
            default_format = (data.delete('format') || 'plain')
            default_options = (data.clone || {})


            keys.each do |k|
              trocla_key = k.delete('key')
              format = (k.delete('format') || default_format)
              other_options = default_options.merge(k)

              if format?(format)
                _hash = trocla_create(trocla_key, format, other_options).merge({'key' => trocla_key})
              end

              _hash.delete('options')

              result << _hash
            end

            result.to_json
          end

          app.post '/v1/key/:trocla_key/:trocla_format' do
            format = params.delete(:trocla_format)
            trocla_key = params.delete(:trocla_key)

            other_options = read_json()

            logger.debug "Create actions with params #{other_options.to_s}"

            if format?(format)
              return trocla_create(trocla_key, format, other_options).to_json
            else
              logger.debug "Bad format #{format} for key #{trocla_key}"
              { 'error' => 'Bad format', 'success' => false }.to_json
            end
          end
        end
      end
    end
  end
end
