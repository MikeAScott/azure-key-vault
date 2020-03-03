# -*- mode: ruby; -*-
$LOAD_PATH.unshift 'lib'
require 'key_vault/version'

Gem::Specification.new do |s|
  s.name      = 'azure-key-vault'
  s.version   = KeyVault::VERSION.split(/[-+]/, 2).first
  s.date      = Time.now.strftime('%Y-%m-%d')
  s.summary   = 'Ruby Client for Azure Key Vault'
  s.homepage  = 'https://github.com/MikeAScott/azure-key-vault'
  s.email     = 'mike.scott2@hiscox.com'
  s.authors   = ['Mike Scott']
  s.license   = 'MIT'

  s.files = (%x[git ls-files]).split($RS) - %w[.gitignore]
  s.require_paths = %w[lib]

  s.add_runtime_dependency 'json_pure',  '~>2.1'
  s.add_runtime_dependency 'rest-client', '~>2.0' 

  s.add_development_dependency 'bundler', '~> 1.12'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rdoc', '~> 4.2'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rb-readline'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-rdoc'
  s.add_development_dependency 'guard-bundler'
end
