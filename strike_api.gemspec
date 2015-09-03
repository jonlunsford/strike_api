# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strike_api/version'

Gem::Specification.new do |spec|
	spec.name          = 'strike_api'
	spec.version       = StrikeAPI::VERSION
	spec.authors       = ['Marshall Ford','Brett Chastain']
	spec.email         = ['inbox@marshallford.me']
	spec.summary       = %q{Wrapper for the Strike API.}
	spec.description   = %q{Wrapper for the Strike Search website/API (https://getstrike.net/torrents/)}
	spec.homepage      = 'https://github.com/marshallford/strike_api'
	spec.license       = 'MIT'

	spec.files         = `git ls-files -z`.split('\x0')
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ['lib']

	spec.add_development_dependency 'bundler'
	spec.add_development_dependency 'rake'
	spec.add_development_dependency 'minitest'
	spec.add_development_dependency 'vcr'
	spec.add_development_dependency 'webmock'
	spec.add_dependency 'httparty'
	spec.add_dependency 'json'
end
