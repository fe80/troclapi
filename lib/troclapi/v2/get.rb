class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Get::Helpers

  post '/v2/get/' do
    data = read_json()
    keys = data.delete('keys')
    default_format = (data.delete('format') || 'plain')
    default_render = (data.delete('render') || '')

    result = []
    keys?(keys)

    keys.each do |k|
      trocla_key = (k.delete('key') || '')
      format = (k.delete('format') || default_format)
      render = (k.delete('render') || default_render)

      _hash = if format?(format)
                trocla_get(trocla_key, format, render).merge({'key' => trocla_key})
              else
                bad_format(trocla_key, format)
              end

      _hash.delete('render')

      result << _hash
    end
    result.to_json
  end


  get '/v2/key/:trocla_key/:trocla_format/?:render?' do
    render = {}
    render['render'] = params.delete(:render)
    format = params.delete(:trocla_format)
    trocla_key = params.delete(:trocla_key)

    if format?(format)
      trocla_get(trocla_key, format, render).to_json
    else
      bad_format(trocla_key, format).to_json
    end
  end
end
