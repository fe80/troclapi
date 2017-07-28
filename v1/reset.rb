def trocla_reset(trocla_key, format, options)
  if trocla_key.empty?
    result = {'error' => 'Missing trocla key', 'success' => false}
    $logger.error "Missing trocla key"
  elsif format.empty?
    result = {'error' => 'Missing format', 'success' => false}
    $logger.error "Missing format for key #{trocla_key}"
  else
    result = {}
    begin
      result['value'] = $trocla.reset_password(
        trocla_key,
        format,
        options
      )
      result['success'] = true
      $logger.debug "Reset value for key #{trocla_key} on format #{format}"
    rescue => e
      $logger.error e.message
      $logger.debug e.backtrace.join("\n")
      status 500
      result = {'error' => e.message, 'success' => false}
    end
  end

  result

end

post '/v1/reset/' do
  request.body.rewind
  data = JSON.parse request.body.read

  result = []

  keys = data.delete('keys')
  default_format = (data.delete('format') || 'plain')
  default_options = (data.clone || {})

  keys.each do |k|
    trocla_key = (k.delete('key') || '')
    format = (k.delete('format') || default_format)
    options = default_options.merge(k)

    if check_format(format)
      _hash = trocla_reset(trocla_key, format, options).merge({'key' => trocla_key})
    end

    _hash.delete('options')

    result << _hash
  end unless keys.nil?

  result.to_json

end

patch '/v1/key/:trocla_key/:trocla_format' do

  format = params.delete(:trocla_format)
  trocla_key = params.delete(:trocla_key)

  options = (params.clone || {})

  $logger.debug "Reset actions with query_string #{options}"

  if check_format(format)
    result = trocla_reset(trocla_key, format, options)
  end

  result.to_json

end
