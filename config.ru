require 'rubygems'
require 'bundler'

Bundler.require

require './p3_app'
run Sinatra::Application
