%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup

require 'eventmachine'
require 'evma_httpserver'
require 'em-mongo'

class EventReceiver < EM::Connection
  include EM::HttpServer

  class << self; attr_accessor :counter end

  def receive_data data
    # params = data.split("\n").last.split(/[&=]/)
    # params = Hash[*params]

    resp = EM::DelegatedHttpResponse.new(self)
    CONN.insert({user:"hello name"}) # params

    EventReceiver.counter += 1

    resp.status = 200
    resp.content = "done inserting"
    resp.send_response
  rescue => e
    resp.status = 500
    resp.content = "http processing error #{e.inspect}"
    resp.send_response
  end
end

EM::run {
  DB = EM::Mongo::Connection.new('localhost').db('event_receiver')
  CONN = DB.collection('test_events') # events

  EM.epoll
  EventReceiver.counter = 0
  EM.add_periodic_timer(1) do
    puts "inserted #{EventReceiver.counter} r/s"
    EventReceiver.counter = 0
  end

  EM::start_server("0.0.0.0", 3000, EventReceiver)
  puts "Listening on 3000 ..."
}
