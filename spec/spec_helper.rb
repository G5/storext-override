require 'bundler/setup'
Bundler.require(:default, :test)
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec-rails'
require 'storext-override'
