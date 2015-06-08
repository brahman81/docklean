Gem::Specification.new do |s|
  s.name        = 'docklean'
  s.version     = '0.0.2'
  s.date        = '2015-04-19'
  s.summary     = "clean up docker containers/images"
  s.description = "helps stay on top of disk utilisation"
  s.authors     = ["Tom Llewellyn-Smith"]
  s.email       = 'code@onixconsulting.co.uk'
  s.files       = [
    'bin/config.yaml',
    'lib/docklean/base.rb',
    'lib/docklean/conf.rb',
    'lib/docklean/containers.rb',
    'lib/docklean/error.rb',
    'lib/docklean/images.rb',
    'lib/docklean.rb',
    'LICENSE',
    'README.md'
  ]
  s.executables << 'docklean.rb'
  s.homepage    = 'https://github.com/brahman81/docklean'
  s.license       = 'GPLv3'
  s.required_ruby_version = '>= 1.9.2'
end
