get '/v1/formats' do
  Trocla::Formats.all.to_json
end

get '/v1/formats/:format' do

  result = {}

  result['available'] = Trocla::Formats.available?(params[:format])

  result.to_json

end
