# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/etcd/version'

Gem::Specification.new do |spec|
  spec.name          = "chef-etcd"
  spec.version       = Chef::Etcd::VERSION
  spec.authors       = ["Ranjib Dey"]
  spec.email         = ["dey.ranjib@gmail.com"]
  spec.description   = %q{Etcd-Chef bindings}
  spec.summary       = %q{Provides chef resource, provider, handler for etcd}
  spec.homepage      = "https://github.com/ranjib/chef-etcd"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "etcd"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
