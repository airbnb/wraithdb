require 'active_record/connection_adapters/abstract/schema_definitions'
require "wraithdb/version"
require 'wraithdb/schema'
require 'wraithdb/column'
require 'wraithdb/adapter'

dir_path = File.expand_path('..', __FILE__)

Dir["#{dir_path}/rails/#{Rails.version[0..2]}/**/*.rb"].each {|file| require file}
Dir["#{dir_path}/gems/**/*.rb"].each { |file|
  gem_name = file.gsub(/.*\/|\..*/, '')
  require file if Gem.loaded_specs.has_key?(gem_name)
}
