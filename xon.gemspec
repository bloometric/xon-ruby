require_relative 'lib/xon'

Gem::Specification.new do |s|
  s.name        = 'xon'
  s.version     = Xon::VERSION
  s.date        = '2011-12-01'
  s.authors     = ['Fouad Mardini', 'Sinan Taifour']
  s.email       = 'code@bloometric.com'
  s.summary     = "A superset of JSON"
  s.description = "Xon is a superset of JSON that supports Time values."
  s.files       = ['lib/xon.rb']
  s.license     = 'MIT'

  s.add_development_dependency 'rake', '~> 12.0'
end
