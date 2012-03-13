$: << File.join(File.expand_path(File.dirname(__FILE__)), "lib")

%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup

require 'eventmachine'
require 'evma_httpserver'
require 'em-mongo'
require 'em-resque'
require 'em-http-request'
require 'pusher.rb'

