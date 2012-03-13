class Pusher
  @queue = :pushing_queue

  def self.perform(hash)
    # params = data.split("\n").last.split(/[&=]/)
    # params = Hash[*params]

    $collection ||= EM::Mongo::Connection.new('localhost').db('event_receiver').collection('test_events')
    $collection.insert(hash)
  end
end
