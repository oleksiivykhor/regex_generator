# RegexGenerator [![Gem Version](https://badge.fury.io/rb/regex_generator.svg)](https://badge.fury.io/rb/regex_generator)

Simple library for generating regular expressions

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'regex_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install regex_generator

## Usage

```ruby
RegexGenerator.generate('45', 'some text 45')
```

You can use additional options to generate regex. For example:

```
RegexGenerator.generate('45', 'some text 45', exact_target: true)
```

So far one option `:exact_target` is available. When it `true` regex will
generated for exact target value

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

- Fork it
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Reques
