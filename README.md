# Guadaloop

This is a simple client library for the Node-GTFS example application, which provides a RESTful API for GTFS transit data. To set up a GTFS API application, see [cobralibre/node-gtfs](https://github.com/cobralibre/node-gtfs) or [brendannee/node-gtfs](https://github.com/brendannee/node-gtfs).

A command line tool for querying information about Austin's Capital Metro bus and rail service is also provided.

## Installation

Add this line to your application's Gemfile:

    gem 'guadaloop'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guadaloop

## Usage

Before you can use this gem, you need to deploy the Node-GTFS example application from [cobralibre/node-gtfs](https://github.com/cobralibre/node-gtfs), then export the `GTFS_API_HOST` environment variable from your shell.

    $ export GTFS_API_HOST='my_node_gtfs_app.herokuapp.com'

    > require 'guadaloop'
    > Guadaloop::get_routes_near(30.267, -97.743, 0.1).each { |r| puts "#{r.route_id}: #{r.route_short_name} #{r.route_long_name}" }
    483: 483 NIGHT OWL RIVERSIDE
    486: 486 NIGHT OWL SOUTH CONGRESS
    990: 990 MANOR/ELGIN EXPRESS
    3: 3 BURNET/MANCHACA
    10: 10 SOUTH 1ST/RED RIVER
    5: 5 WOODROW/SOUTH 5TH
    4: 4 MONTOPOLIS 
    21: 21 EXPOSITION
    17: 17 CESAR CHAVEZ
    7: 7 DUVAL / DOVE SPRINGS
    20: 20 MANOR RD/RIVERSIDE
    100: 100 AIRPORT FLYER
    30: 30 BARTON CREEK SQ 
    101: 101 N LAMAR/S CONGRESS LTD
    22: 22 CHICON
    122: 122 FOUR POINTS LIMITED
    127: 127 DOVE SPRINGS FLYER
    142: 142 METRIC FLYER
    1001: 1L NORTH LAMAR/SOUTH CONGRESS VIA LAMAR
    2001: 1M NORTH LAMAR/SOUTH CONGRESS VIA METRIC
    ...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
