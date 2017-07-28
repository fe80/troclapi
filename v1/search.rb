def trocla_search(trocla_key)
  if trocla_key.empty?
    result = {'error' => 'Missing trocla key', 'success' => false}
    $logger.error "Missing trocla key"
  else
    begin
      result = {}
      trocla_key.each do |key|
        _search = $trocla.search_key(key)
        if _search.empty?
          result[key] = nil
        else
          result[key] = _search
        end
      end
      result['success'] = true
    rescue => e
      $logger.error e.message
      $logger.debug e.backtrace.join("\n")
      status 500
      result = {'error' => e.message, 'success' => false}
    end
  end
  result
end

post '/v1/search/' do
  request.body.rewind
  data = JSON.parse request.body.read

  content_type :text
  keys = (data.delete('keys') || [])

  $logger.debug "Search trocla key with json value #{keys.to_s}"

  result = {}

  result['keys'] = trocla_search(keys)

  result.to_json

end
