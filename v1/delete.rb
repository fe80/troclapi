def trocla_delete(trocla_key, format)

  if trocla_key.empty?
    result = {'error' => 'Missing trocla key', 'success' => false}
    $logger.error "Missing trocla key"
  elsif format.empty?
    result = {'error' => 'Missing format', 'success' => false}
    $logger.error "Missing format for key #{trocla_key}"
  else
    result = {}
    begin
      result['value'] = $trocla.delete_password(
        trocla_key,
        format
      )
      if result['value'].nil?
        result = {'error' => 'Key not found on this format', 'success' => false}
        $logger.debug "Delete value for key #{trocla_key} on format #{format} not found"
      else
        result['success'] = true
        $logger.debug "Delete value for key #{trocla_key} on format #{format}"
      end
    rescue => e
      $logger.error e.message
      $logger.debug e.backtrace.join("\n")
      status 500
      result = {'error' => e.message, 'success' => false}
    end
  end

  result
end

post '/v1/delete/' do
  request.body.rewind
  data = JSON.parse request.body.read

  result = []

  keys = data.delete('keys')
  default_format = (data.delete('format') || 'plain')

  keys.each do |k|
    trocla_key = (k.delete('key') || '')
    format = (k.delete('format') || default_format)

    if check_format(format)
      _hash = trocla_delete(trocla_key, format).merge({'key' => trocla_key})
    else
      _hash = {'error' => 'Bad format', 'success' => false}
      $logger.debug "Bad format #{format} for key #{trocla_key}"
    end

    result << _hash
  end unless keys.nil?

  result.to_json

end

delete '/v1/key/:trocla_key/:trocla_format' do

  format = params.delete(:trocla_format)
  trocla_key = params.delete(:trocla_key)

  if check_format(format)
    result = trocla_delete(trocla_key, format)
  else
    result = {'error' => 'Bad format', 'success' => false}
    $logger.debug "Bad format #{format} for key #{trocla_key}"
  end

  result.to_json

end
