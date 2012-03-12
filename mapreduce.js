// all emails did events: register > login > view_home_page > pay_order
// and gender, age, browser, country distribution
// and convert rate for each step.

use event_receiver;

var map = function() {
  emit(
    this.email,  // reduce and finalize's key
    {"event":this.events} // reduce's value in values
  );
}

var reduce = function(key, values) {
  events_chain = ['register', 'login', 'view_home_page', 'pay_order']

  for (var i in values) {
    if(values[i] && events_chain[0] == values[i].event) {
      events_chain.shift()
    }
  }

  if(events_chain.length == 0) {
    return key; // <= finalize's value
  }
}

var finalize = function(key, value) {
  print(key)
  return 123 // <= value of the key.
}

db.events.mapReduce(map, reduce, {finalize:finalize, query: {}, out: 'totals'});