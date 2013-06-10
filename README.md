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
    > Guadaloop::get_routes_near(30.267, -97.743, 0.1).each { |route| puts "#{route['route_long_name']}: #{route['route_id']}" }
    NIGHT OWL RIVERSIDE: 483
    MANOR/ELGIN EXPRESS: 990
    NORTH LAMAR/SOUTH CONGRESS VIA METRIC: 2001
    NORTH LAMAR/SOUTH CONGRESS VIA LAMAR: 1001
    BURNET/MANCHACA: 3
    DUVAL / DOVE SPRINGS: 7
    SOUTH 1ST/RED RIVER: 10
    CESAR CHAVEZ: 17
    MANOR RD/RIVERSIDE: 20
    CHICON: 22
    AIRPORT FLYER: 100
    N LAMAR/S CONGRESS LTD: 101
    WOODROW/SOUTH 5TH: 5
    BARTON CREEK SQ : 30
    METRIC FLYER: 142
    NIGHT OWL SOUTH CONGRESS: 486

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
