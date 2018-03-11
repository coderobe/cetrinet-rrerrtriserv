# Rrerrtriserv

Server for whatever this is gonna be.

## Requirements

* Ruby 2.3 or newer
* Redis

## Installation

In the Future™, you will be able to just `gem install` this.  For the time
being, this will have to do:

```sh
# install bundler if not already installed
gem install bundler

# install the gems
bundle install
```

This installs the dependencies of this thing.

## Building a .jar

When running inside JRuby, you can use Warbler to package rrerrtriserv as an
executable .jar file.  This can be done by simply running:

```sh
warble
```

This will create a `./dist/rrerrtriserv.jar` file which can be run on any Java
8 virtual machine.

## Usage

To start the server:

```sh
bundle exec ./exe/rrerrtriserv start
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/rrerrnet/rrerrtriserv.

## License

The gem is available as open source under the terms of
the [BSD-2-Clause](https://opensource.org/licenses/BSD-2-Clause).
