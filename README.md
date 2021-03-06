# Ruby IG Markets Dealing Platform Gem

[![Gem][gem-badge]][gem-link]
[![Build Status][travis-ci-badge]][travis-ci-link]
[![Test Coverage][test-coverage-badge]][test-coverage-link]
[![Code Climate][code-climate-badge]][code-climate-link]
[![Dependencies][dependencies-badge]][dependencies-link]
[![Documentation][documentation-badge]][documentation-link]
[![License][license-badge]][license-link]

Easily access the IG Markets Dealing Platform from Ruby with this gem, either directly through code or by using the
provided command-line client. Written against the [official REST API](http://labs.ig.com/rest-trading-api-reference).

Includes support for:

- Activity and transaction history
- Positions
- Sprint market positions
- Working orders
- Market navigation, searches and snapshots
- Historical prices
- Watchlists
- Client sentiment
- Authentication profiles
- Live streaming of account, trade and market updates

An IG Markets live or demo trading account is needed in order to use this gem.

## License

Licensed under the MIT license. You must read and agree to its terms to use this software.

## Installation

Install the latest version of the `ig_markets` gem with the following command:

```
$ gem install ig_markets
```

## Usage — Command-Line Client

The general form for invoking the command-line client is:

```
$ ig_markets COMMAND [SUBCOMMAND] --username USERNAME --password PASSWORD --api-key API-KEY [--demo] [...]
```

#### Config File

On startup `ig_markets` looks for config files at `./.ig_markets.yml` and `~/.ig_markets.yml`. These are YAML files that
can hold named sets of predefined authentication profiles in order to avoid having to specify these repeatedly on the
command-line for every invocation.

The desired authentication profile is specified using the `--profile` command-line argument, and if the `--profile`
argument is omitted then the `default` profile will be used.

Here is an example of a config file with a `default` profile and a `demo` profile:

```yaml
profiles:
  default:
    username: USERNAME
    password: PASSWORD
    api-key: API-KEY

  demo:
    username: DEMO-USERNAME
    password: DEMO-PASSWORD
    api-key: DEMO-API-KEY
    demo: true
```

The following examples assume the presence of a config file that contains a valid default authentication profile.
    
#### Commands

Use `ig_markets help` to get details on the options accepted by the commands and subcommands. The list of available
commands and their subcommands is:

- `ig_markets account`
- `ig_markets activities --days N [...]`
- `ig_markets confirmation DEAL-REFERENCE`
- `ig_markets console`
- `ig_markets help [COMMAND]`
- `ig_markets markets EPICS`
- `ig_markets orders [list]`
- `ig_markets orders create ...`
- `ig_markets orders update DEAL-ID ...`
- `ig_markets orders delete DEAL-ID`
- `ig_markets orders delete-all`
- `ig_markets performance --days N [...]`
- `ig_markets positions [list] [...]`
- `ig_markets positions create ...`
- `ig_markets positions update DEAL-ID ...`
- `ig_markets positions close DEAL-ID [...]`
- `ig_markets positions close-all [...]`
- `ig_markets prices --epic EPIC --resolution RESOLUTION ...`
- `ig_markets search QUERY [--type TYPE]`
- `ig_markets self-test`
- `ig_markets sentiment MARKET`
- `ig_markets sprints [list]`
- `ig_markets sprints create ...`
- `ig_markets stream [dashboard] [...]`
- `ig_markets stream raw ...`
- `ig_markets transactions --days N [...]`
- `ig_markets watchlists [list]`
- `ig_markets watchlists create NAME [EPIC ...]`
- `ig_markets watchlists add-markets WATCHLIST-ID [EPIC ...]`
- `ig_markets watchlists remove-markets WATCHLIST-ID [EPIC ...]`
- `ig_markets watchlists delete WATCHLIST-ID`

#### Examples

```shell
# Print account details and balances
ig_markets account

# Print EUR/USD transactions from the last week, excluding interest transactions
ig_markets transactions --days 7 --instrument EUR/USD --no-interest

# Search for EURUSD currency markets
ig_markets search EURUSD --type currencies

# Print details for the EURUSD pair and the Dow Jones Industrial Average
ig_markets markets CS.D.EURUSD.CFD.IP IX.D.DOW.IFD.IP

# Print current positions in aggregate
ig_markets positions --aggregate

# Create a EURUSD long position of size 2
ig_markets positions create --direction buy --epic CS.D.EURUSD.CFD.IP --size 2 --currency-code USD

# Change the limit and stop levels for an existing position
ig_markets positions update DEAL-ID --limit-level 1.15 --stop-level 1.10

# Fully close a position
ig_markets positions close DEAL-ID

# Partially close a position (assuming its size is greater than 1)
ig_markets positions close DEAL-ID --size 1

# Create a EURUSD sprint market short position of size 100 that expires in 20 minutes
ig_markets sprints create --direction sell --epic FM.D.EURUSD24.EURUSD24.IP --expiry-period 20
                          --size 100

# Create a working order to buy 1 unit of EURUSD at the level 1.1
ig_markets orders create --direction buy --epic CS.D.EURUSD.CFD.IP --level 1.1 --size 1 --type limit
                         --currency-code USD

# Print daily prices for EURUSD from the last two weeks
ig_markets prices --epic CS.D.EURUSD.CFD.IP --resolution day --number 14

# Print account dealing performance from the last 90 days, broken down by the EPICs that were traded
ig_markets performance --days 90

# Print an updating live display of accounts, positions and working orders (requires the curses gem)
ig_markets stream

# Print raw streaming details of account balances, trading actions, and the price of the EURUSD pair
ig_markets stream raw --accounts --trades --markets CS.D.EURUSD.CFD.IP

# Log in and open a Ruby console which can be used to query the IG API, printing all REST requests
ig_markets console --verbose
```

## Usage — Library

#### Documentation

API documentation is available [here](http://www.rubydoc.info/github/rviney/ig_markets/master).

#### Examples

```ruby
require 'ig_markets'

ig = IGMarkets::DealingPlatform.new

# Session
ig.sign_in 'username', 'password', 'api_key', :demo
ig.sign_out

one_week = 7 * 24 * 60 * 60
two_weeks = 14 * 24 * 60 * 60

# Account
ig.account.all
ig.account.activities from: Time.now - one_week
ig.account.activities from: Time.now - one_week, to: Time.now - one_week
ig.account.transactions from: Time.now - one_week
ig.account.transactions from: Time.now - two_weeks, to: Time.now - one_week
ig.account.transactions from: Time.now - two_weeks, to: Time.now - one_week, type: :withdrawal

# Dealing
ig.deal_confirmation 'deal_reference'

# Positions
ig.positions.all
ig.positions.create currency_code: 'USD', direction: :buy, epic: 'CS.D.EURUSD.CFD.IP', size: 2
position = ig.positions['deal_id']
position.profit_loss
position.update limit_level: 1.2, stop_level: 1.1
position.reload
position.close

# Sprint market positions
ig.sprint_market_positions.all
ig.sprint_market_positions.create direction: :buy, epic: 'FM.D.EURUSD24.EURUSD24.IP',
                                  expiry_period: :twenty_minutes, size: 100
sprint_market_position = ig.sprint_market_positions['deal_id']

# Working orders
ig.working_orders.all
ig.working_orders.create currency_code: 'USD', direction: :buy, epic: 'CS.D.EURUSD.CFD.IP',
                         level: 0.99, size: 1, type: :limit
working_order = ig.working_orders['deal_id']
working_order.update level: 1.25, limit_distance: 50, stop_distance: 50
working_order.reload
working_order.delete

# Markets
ig.markets.hierarchy
ig.markets.search 'EURUSD'
ig.markets.find 'CS.D.EURUSD.CFD.IP', 'IX.D.DOW.IFD.IP'
market = ig.markets['CS.D.EURUSD.CFD.IP']
market.historical_prices resolution: :hour, number: 48
market.historical_prices resolution: :second, from: Time.now - 120, to: Time.now - 60

# Watchlists
ig.watchlists.all
ig.watchlists.create 'New Watchlist', 'CS.D.EURUSD.CFD.IP', 'UA.D.AAPL.CASH.IP'
watchlist = ig.watchlists['watchlist_id']
watchlist.markets
watchlist.add_market 'CS.D.EURUSD.CFD.IP'
watchlist.remove_market 'CS.D.EURUSD.CFD.IP'
watchlist.delete

# Client sentiment
client_sentiment = ig.client_sentiment['EURUSD']
client_sentiment.related_sentiments
client_sentiment.reload

# Miscellaneous
ig.applications

# Streaming
queue = Queue.new

ig.streaming.connect
ig.streaming.on_error { |error| queue.push error }

subscription = ig.streaming.build_accounts_subscription
subscription.on_data { |data, _merged_data| queue.push data }
ig.streaming.start_subscriptions subscription, snapshot: true

loop do
  data = queue.pop
  raise data if data.is_a? Lightstreamer::LightstreamerError

  puts data.inspect
end
```

## Contributors

Gem created by Richard Viney. All contributions welcome.

[gem-link]: https://rubygems.org/gems/ig_markets
[gem-badge]: https://badge.fury.io/rb/ig_markets.svg
[travis-ci-link]: http://travis-ci.org/rviney/ig_markets
[travis-ci-badge]: https://travis-ci.org/rviney/ig_markets.svg?branch=master
[test-coverage-link]: https://codeclimate.com/github/rviney/ig_markets/coverage
[test-coverage-badge]: https://codeclimate.com/github/rviney/ig_markets/badges/coverage.svg
[code-climate-link]: https://codeclimate.com/github/rviney/ig_markets
[code-climate-badge]: https://codeclimate.com/github/rviney/ig_markets/badges/gpa.svg
[dependencies-link]: https://gemnasium.com/rviney/ig_markets
[dependencies-badge]: https://gemnasium.com/rviney/ig_markets.svg
[documentation-link]: https://inch-ci.org/github/rviney/ig_markets
[documentation-badge]: https://inch-ci.org/github/rviney/ig_markets.svg?branch=master
[license-link]: https://github.com/rviney/ig_markets/blob/master/LICENSE.md
[license-badge]: https://img.shields.io/badge/license-MIT-blue.svg
