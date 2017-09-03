class Troclapi < Sinatra::Base

  actions = (Trocla.new.config['api']['actions'] || [ 'format', 'create', 'get', 'set', 'reset', 'delete', 'search' ])

  actions.each do |action|
    require "troclapi/helpers/#{action}" unless action == 'format'
    require "troclapi/v1/#{action}"
  end

end
