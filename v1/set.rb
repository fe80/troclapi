def trocla_set(trocla_key, format, value)

  if trocla_key.empty?
    result = {'error' => 'Missing trocla key', 'success' => false}
    $logger.error "Missing trocla key"
  elsif format.empty?
    result = {'error' => 'Missing format', 'success' => false}
    $logger.error "Missing format for key #{trocla_key}"
  elsif value.empty?
    result = {'error' => 'Missing value', 'success' => false}
    $logger.error "Missing value for key #{trocla_key}"
  else
    result = {}
    begin
      result['value'] = $trocla.set_password(
        trocla_key,
        format,
        value
      )
      result['success'] = true
      $logger.debug "Set value for key #{trocla_key} on format #{format}"
    rescue => e
      $logger.error e.message
      $logger.debug e.backtrace.join("\n")
      status 500
      result = {'error' => e.message, 'success' => false}
    end
  end
  result
end

post '/v1/set/' do
  request.body.rewind
  data = JSON.parse request.body.read

  keys = data.delete('keys')

  default_format = (data.delete('format') || 'plain')

  keys.each do |k|
    trocla_key = (k.delete('key') || '')
    format = (k.delete('format') || default_format)
    value = (k.delete('value') || '')

    if check_format(format)
      _hash = trocla_set(trocla_key, format, value)
    else
      _hash = {'error' => 'Bad format', 'success' => false}
      $logger.debug "Bad format #{format} for key #{trocla_key}"
    end

    result << _hash
  end unless keys.nil?

  result.to_json

end

put '/v1/key/:trocla_key/:trocla_format' do

  format = params.delete(:trocla_format)
  trocla_key = params.delete(:trocla_key)

  request.body.rewind
  data = JSON.parse request.body.read
  value = data.delete('value')

  if check_format(format)
    result = trocla_set(trocla_key, format, value)
  else
    result = {'error' => 'Bad format', 'success' => false}
    $logger.debug "Bad format #{format} for key #{trocla_key}"
  end

  result.to_json

end
