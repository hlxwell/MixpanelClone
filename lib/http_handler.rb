class HttpHandler < EM::Connection
  include EM::HttpServer

  class << self; attr_accessor :counter end

  def receive_data data
    # params = data.split("\n").last.split(/[&=]/)
    # params = Hash[*params]

    resp = EM::DelegatedHttpResponse.new(self)

    # $collection.insert({user:"hello name"})
    Resque.enqueue(Pusher, {user:"hello name"})

    resp.status = 200
    resp.content = "done inserting"
    resp.send_response
  rescue => e
    resp.status = 500
    resp.content = "http processing error #{e.inspect}"
    resp.send_response
  end
end