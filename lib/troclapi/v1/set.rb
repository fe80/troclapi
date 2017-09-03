class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Set::Helpers

  post '/v1/set/' do
    data = read_json()
    keys = data.delete('keys')
    default_format = (data.delete('format') || 'plain')

    result = []
    keys?(keys)

    keys.each do |k|
      trocla_key = (k.delete('key') || '')
      format = (k.delete('format') || default_format)
      value = (k.delete('value') || '')

      _hash = if format?(format)
                trocla_set(trocla_key, format, value)
              else
                bad_format(trocla_key, format)
              end

      result << _hash
    end unless keys.nil?

    result.to_json
  end

  put '/v1/key/:trocla_key/:trocla_format' do
    format = params.delete(:trocla_format)
    trocla_key = params.delete(:trocla_key)
    data = read_json()
    value = (data.delete('value') || '')

    if format?(format)
      trocla_set(trocla_key, format, value).to_json
    else
      bad_format(trocla_key, format).to_json
    end
  end
end
