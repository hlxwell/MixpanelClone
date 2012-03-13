%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup

require 'eventmachine'
require 'em-http-request'

class RandomUser
  DATA_POOL = {
    email: (1..1000).to_a.map { |i| "test#{i}@gmail.com" },
    gender: %w{M W},
    age: (10..60).to_a,
    browser: %w{IE6 IE7 IE8 Firefox Chrome Safari},
    country: %w{zh ja us au nl uk ca be es po de},
    events: %w{visit_product_list view_home_page register login visit_product_show directly_buy_product pay_order add_product_to_cart}
  }

  def self.get
    user = {}
    DATA_POOL.keys.each do |key|
      user[key] = DATA_POOL[key].sample # choice 1.8.7
    end
    user
  end
end

EM.run do
  EM.add_periodic_timer(0.001) do
    request = EventMachine::HttpRequest.new("http://localhost:3000/").post({ body: RandomUser.get })
    request.callback { |http| puts "success #{http.response}" }
    request.errback { |error| puts "error #{error.inspect}"; EM.stop }
  end
end
