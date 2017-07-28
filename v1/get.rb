def trocla_get(trocla_key, format, options)

  if trocla_key.empty?
    result = {'error' => 'Missing trocla key', 'success' => false}
    $logger.error "Missing trocla key"
  elsif format.empty?
    result = {'error' => 'Missing format', 'success' => false}
    $logger.error "Missing format for key #{trocla_key}"
  else
    result = {}
    begin
      result['value'] = $trocla.get_password(
        trocla_key,
        format,
        options
      )
      if result['value'].nil?
        result = {'error' => 'Key not found on this format', 'success' => false}
        $logger.debug "Get value for key #{trocla_key} on format #{format}"
      else
        result['success'] = true
        $logger.debug "Get value for key #{trocla_key} on format #{format}"
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

post '/v1/get/' do
  request.body.rewind
  data = JSON.parse request.body.read

  result = []

  keys = data.delete('keys')
  default_format = (data.delete('format') || 'plain')
  default_render = (data.delete('render') || '')

  keys.each do |k|
    trocla_key = (k.delete('key') || '')
    format = (k.delete('format') || default_format)
    render = (k.delete('render') || default_render)

    if check_format(format)
      _hash = trocla_get(trocla_key, format, render).merge({'key' => trocla_key})
    else
      _hash = {'error' => 'Bad format', 'success' => false}
      $logger.debug "Bad format #{format} for key #{trocla_key}"
    end

    _hash.delete('render')

    result << _hash
  end unless keys.nil?

  result.to_json

end


get '/v1/key/:trocla_key/:trocla_format/?:render?' do

  render = {}
  render['render'] = params.delete(:render)

  format = params.delete(:trocla_format)
  trocla_key = params.delete(:trocla_key)

  if check_format(format)
    result = trocla_get(trocla_key, format, render)
  else
    result = {'error' => 'Bad format', 'success' => false}
    $logger.debug "Bad format #{format} for key #{trocla_key}"
  end

  result.to_json

end
