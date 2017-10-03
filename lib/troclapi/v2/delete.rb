class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Delete::Helpers

  post '/v2/delete/' do
    data = read_json()
    keys = data.delete('keys')
    default_format = (data.delete('format') || 'plain')

    result = []
    keys?(keys)

    keys.each do |k|
      trocla_key = (k.delete('key') || '')
      format = (k.delete('format') || default_format)

      _hash = if format?(format)
                trocla_delete(trocla_key, format).merge({'key' => trocla_key})
              else
                bad_format(trocla_key, format)
              end

      result << _hash
    end

    result.to_json
  end

  delete '/v2/key/:trocla_key/:trocla_format' do
    format = params.delete(:trocla_format)
    trocla_key = params.delete(:trocla_key)

    if format?(format)
      trocla_delete(trocla_key, format).to_json
    else
      bad_format(trocla_key, format).to_json
    end
  end
end
