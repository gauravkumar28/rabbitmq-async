
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rabbitmq/async/version"

Gem::Specification.new do |spec|
  spec.name          = "rabbitmq-async"
  spec.version       = Rabbitmq::Async::VERSION
  spec.authors       = ["Gaurav Kumar"]
  spec.email         = ["gaurav.sachin.007@gmail.com"]

  spec.summary       = %q{Ruby Gem to call Class methos Asynchronously using Rabbitmq}
  spec.description   = %q{It is similar to resque, but uses rabbitmq}
  spec.homepage      = "https://github.com/gauravkumar28/rabbitmq-async"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_dependency "bunny", '~> 2.7' 
  spec.add_dependency "json", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
