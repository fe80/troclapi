module Sinatra
  module Troclapi
    module V1
      module Format
        def self.registered(app)
          app.get '/v1/formats' do
            Trocla::Formats.all.to_json
          end

          app.get '/v1/formats/:format' do
            { 'available' => Trocla::Formats.available?(params[:format]).to_json }
          end
        end
      end
    end
  end
end
