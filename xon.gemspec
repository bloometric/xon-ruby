require_relative 'lib/xon'

Gem::Specification.new do |s|
  s.name        = 'xon'
  s.version     = Xon::VERSION
  s.date        = '2011-12-01'
  s.summary     = "Xon: A Superset of JSON"
  s.description = <<-DESCRIPTION
    Xon is a superset of JSON that supports Time values.
  DESCRIPTION
  s.authors     = ['Fouad Mardini', 'Sinan Taifour']
  s.email       = 'code@bloometric.com'
  s.files       = ['lib/xon.rb']
  s.license       = 'MIT'
end
