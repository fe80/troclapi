class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Formats::Helpers

  get '/v2/formats' do
    { :success => true, :available => Trocla::Formats.all }.to_json
  end

  get '/v2/formats/:format' do
    { :success=> true, :available => Trocla::Formats.available?(params[:format]) }.to_json
  end

  get '/v2/formats/:trocla_key/' do
    trocla_key = params.delete(:trocla_key)
    trocla_formats(trocla_key).to_json
  end

  get '/v2/formats/:trocla_key/:trocla_format' do
    trocla_key = params.delete(:trocla_key)
    format = params.delete(:trocla_format)

    if format?(format)
      { :success => true, :available => trocla_formats?(trocla_key, format) }.to_json
    else
      bad_format(trocla_key, format).to_json
    end
  end

  post '/v2/formats/' do
    data = read_json()
    keys = (data.delete('keys') || [])
    result = []
    keys?(keys)

    keys.each do |trocla_key|
      result << trocla_formats(trocla_key).merge({:key => trocla_key})
      logger.debug result.to_s
    end
    result.to_json
  end
end
