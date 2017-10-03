require 'yaml'
class Troclapi < Sinatra::Base
  get '/version' do
    versions = YAML.load_file(settings.root + '/VERSION')
    versions['version'] = [versions['major'], versions['minor'], versions['patch']].join('.')
    versions.to_json
  end
end
