class Troclapi < Sinatra::Base

  before '/v2/*' do
    authorize!
  end

  actions = (Trocla.new.config['api']['actions'] || [ 'formats', 'create', 'get', 'set', 'reset', 'delete', 'search' ])

  actions.each do |action|
    require "troclapi/helpers/#{action}"
    require "troclapi/v2/#{action}"
  end

end
