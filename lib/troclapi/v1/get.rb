module Sinatra
  module Troclapi
    module V1
      module Get
        def self.registered(app)
            app.post '/v1/get/' do

            data = read_json()
            keys = data.delete('keys')
            default_format = (data.delete('format') || 'plain')
            default_render = (data.delete('render') || '')

            result = []

            keys.each do |k|
              trocla_key = (k.delete('key') || '')
              format = (k.delete('format') || default_format)
              render = (k.delete('render') || default_render)

              if format?(format)
                _hash = trocla_get(trocla_key, format, render).merge({'key' => trocla_key})
              else
                _hash = {'error' => 'Bad format', 'success' => false}
                $logger.debug "Bad format #{format} for key #{trocla_key}"
              end

              _hash.delete('render')

              result << _hash
            end unless keys.nil?
            result.to_json
          end


          app.get '/v1/key/:trocla_key/:trocla_format/?:render?' do
            render = {}
            render['render'] = params.delete(:render)
            format = params.delete(:trocla_format)
            trocla_key = params.delete(:trocla_key)

            if format?(format)
              return trocla_get(trocla_key, format, render).to_json
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
