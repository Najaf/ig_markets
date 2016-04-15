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

* Activity and transaction history
* Positions
* Sprint market positions
* Working orders
* Market navigation, searches and snapshots
* Historical prices
* Watchlists
* Client sentiment

An IG Markets production or demo trading account is needed in order to use this gem.

## License

Licensed under the MIT license. You must read and agree to its terms to use this software.

## Usage — Command-Line Client

```sh
$ gem install ig_markets

Usage: ig_markets <command> --username=<username> --password=<password> --api-key=<api-key> [--demo]
```

On startup `ig_markets` searches for files named `"./.ig_markets"` and then `"~/.ig_markets"`, and if they are present
interprets their contents as command-line arguments. This can be used to avoid having to specify authentication details
with every invocation. To do this create a file at `"./.ig_markets"` or `"~/.ig_markets"` with the following contents:

```
--username=<username>
--password=<password>
--api-key=<api-key>
# (include if this is a demo account) --demo
```

Run `ig_markets help` to list details on available commands. The full list of commands is:

- `ig_markets account`
- `ig_markets activities [--days=3]`
- `ig_markets confirmation --deal-reference=<...>`
- `ig_markets orders`
- `ig_markets positions`
- `ig_markets search --query=<...>`
- `ig_markets sentiment --market=<...> [--related]`
- `ig_markets sprints`
- `ig_markets transactions [--days=3]`
- `ig_markets watchlists`

Note: at present there is no support in the command-line client for creating/updating/deleting positions, orders, etc...

## Usage — Library

```ruby
ig = IGMarkets::DealingPlatform.new

# Session
ig.sign_in 'username', 'password', 'api_key', :demo
ig.sign_out

# Account
ig.account.all
ig.account.recent_activities 24 * 60 * 60
ig.account.recent_transactions 24 * 60 * 60
ig.account.activities_in_date_range Date.today - 14, Date.today - 7
ig.account.transactions_in_date_range Date.today - 14, Date.today - 7

# Dealing
ig.deal_confirmation 'deal_reference'

# Positions
ig.positions.all
ig.positions.create currency_code: 'USD', direction: :buy, epic: 'CS.D.EURUSD.CFD.IP', size: 2
ig.positions['deal_id']
ig.positions['deal_id'].profit_loss
ig.positions['deal_id'].update limit_level: 1.2, stop_level: 1.1
ig.positions['deal_id'].close

# Sprint market positions
ig.sprint_market_positions.all
ig.sprint_market_positions.create direction: :buy, epic: 'FM.D.EURUSD24.EURUSD24.IP',
                                  expiry_period: :one_minute, size: 100

# Working orders
ig.working_orders.all
ig.working_orders.create currency_code: 'USD', direction: :buy, epic: 'CS.D.EURUSD.CFD.IP', level: 0.99,
                         size: 1, time_in_force: :good_till_cancelled, type: :limit
ig.working_orders['deal_id']
ig.working_orders['deal_id'].update level: 1.25, limit_distance: 50, stop_distance: 0.02
ig.working_orders['deal_id'].delete

# Markets
ig.markets.hierarchy
ig.markets.search 'EURUSD'
ig.markets['CS.D.EURUSD.CFD.IP']
ig.markets['CS.D.EURUSD.CFD.IP'].recent_prices :day, 10
ig.markets['CS.D.EURUSD.CFD.IP'].prices_in_date_range :day, Date.today - 14, Date.today - 7

# Watchlists
ig.watchlists.all
ig.watchlists.create 'New Watchlist', 'CS.D.EURUSD.CFD.IP', 'UA.D.AAPL.CASH.IP'
ig.watchlists['watchlist_id']
ig.watchlists['watchlist_id'].markets
ig.watchlists['watchlist_id'].add_market 'CS.D.EURUSD.CFD.IP'
ig.watchlists['watchlist_id'].remove_market 'CS.D.EURUSD.CFD.IP'
ig.watchlists['watchlist_id'].delete

# Client sentiment
ig.client_sentiment['EURUSD']
ig.client_sentiment['EURUSD'].related_sentiments

# Miscellaneous
ig.applications
```

## Documentation

API documentation is available [here](http://www.rubydoc.info/github/rviney/ig_markets/master).

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
