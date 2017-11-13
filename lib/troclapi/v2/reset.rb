class Troclapi < Sinatra::Base
  helpers Sinatra::Troclapi::Reset::Helpers

  post '/v2/reset/' do
    data = read_json()
    keys = data.delete('keys')
    default_format = (data.delete('format') || 'plain')
    default_options = (data.clone || {})

    result = []
    keys?(keys)

    keys.each do |k|
      trocla_key = (k.delete('key') || '')
      format = (k.delete('format') || default_format)
      other_options = default_options.merge(k)

      _hash =  if format?(format)
                 trocla_reset(trocla_key, format, other_options).merge({'key' => trocla_key})
               else
                 bad_format(trocla_key, format)
               end

      _hash.delete('options')

      result << _hash
    end

    result.to_json

  end

  patch '/v2/key/:trocla_key/:trocla_format' do
    format = params.delete(:trocla_format)
    trocla_key = params.delete(:trocla_key)
    other_options = read_json()

    logger.debug "Reset actions with query_string #{other_options}"

    if format?(format)
      trocla_reset(trocla_key, format, other_options).to_json
    else
      bad_format(trocla_key, format).to_json
    end
  end
end
