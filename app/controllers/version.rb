# frozen_string_literal: true

require 'yaml'

#
# This class return troclapi release
#
class Troclapi < Sinatra::Base
  # Get the api version
  #
  # @return [Hash]
  get '/version' do
    versions = YAML.load_file(
      File.absolute_path(format('%s/../../../VERSION', __FILE__))
    )
    versions['version'] = [
      versions['major'], versions['minor'], versions['patch']
    ].join('.')
    versions.to_json
  end
end
