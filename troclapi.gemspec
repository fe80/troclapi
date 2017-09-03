Gem::Specification.new do |s|
  s.name        = 'troclapi'
  s.version     = '0.0.1'
  s.date        = '2017-07-21'
  s.summary     = 'Troclapi'
  s.description = 'Simple REST Api for trocla'
  s.authors     = ['fe80']
  s.email       = 'gem@p0l.io'
  s.files       = [
    'bin/troclapi',
    'Gemfile',
    'docker_example/Dockerfile',
    'docker_example/troclarc.yaml',
    'lib/troclapi/trocla.rb',
    'lib/troclapi/helpers.rb',
    'lib/troclapi/login.rb',
    'lib/troclapi/helpers/delete.rb',
    'lib/troclapi/helpers/set.rb',
    'lib/troclapi/helpers/search.rb',
    'lib/troclapi/helpers/reset.rb',
    'lib/troclapi/helpers/create.rb',
    'lib/troclapi/helpers/login.rb',
    'lib/troclapi/helpers/get.rb',
    'lib/troclapi/v1.rb',
    'lib/troclapi/v1/delete.rb',
    'lib/troclapi/v1/format.rb',
    'lib/troclapi/v1/set.rb',
    'lib/troclapi/v1/search.rb',
    'lib/troclapi/v1/reset.rb',
    'lib/troclapi/v1/create.rb',
    'lib/troclapi/v1/get.rb',
    'lib/troclapi/version.rb',
    'lib/troclapi.rb',
  ]
  s.homepage    =
    'https://github.com/fe80/troclapi'
  s.license     = 'MIT'
  s.executables << 'troclapi'
end
