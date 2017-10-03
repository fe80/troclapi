class Troclapi < Sinatra::Base
  get '/v2/formats' do
    Trocla::Formats.all.to_json
  end

  get '/v2/formats/:format' do
    { 'available' => Trocla::Formats.available?(params[:format]).to_json }
  end
end
