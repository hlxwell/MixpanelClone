$: << File.join(File.expand_path(File.dirname(__FILE__)), "..")

require 'init.rb'
require 'http_handler.rb'

EM::run {
  EM.epoll

  # $db = EM::Mongo::Connection.new('localhost').db('event_receiver')
  # $collection = $db.collection('test_events')

  EM::start_server("0.0.0.0", 3000, HttpHandler)
  puts "Listening on 3000 ..."
}
