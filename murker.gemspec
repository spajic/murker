lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'murker/version'

def add_dev_dependencies(spec)
  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'aruba', '~> 0.6.2'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end

Gem::Specification.new do |spec|
  spec.name          = 'murker'
  spec.version       = Murker::VERSION
  spec.authors       = ['Andrey Deryabin']
  spec.email         = ['aderyabin@evilmartians.com']

  spec.summary       = 'Test request-response schema automatically'
  spec.description   = 'Test request-response schema automatically'
  spec.homepage      = 'https://github.com/aderyabin/murker'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'diffy'
  spec.add_dependency 'json-schema-generator'

  add_dev_dependencies(spec)
end
