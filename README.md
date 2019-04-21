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
You can pass target as hash to generate regex with named capturing groups.

You can use additional options to generate regex. For example:

```ruby
RegexGenerator.generate('45', 'some text 45', exact_target: true)
```

Or use from command line:

    $ generate_regex "target" "text or path/to/file" [options]

Allowed options:
 - `:exact_target` - When it `true` regex will generated for exact target value
 - `:self_recognition` - Symbols that will be represented as itself. Can be string or array
 - `:look` - `:ahead` or `:behind` (`:behind` by default). To generate regex with text after or before the value
 - `:strict_count` - When it `true` regex will generated with strict chars count
 - `:title` - Regex will generated for provided title. If `:title` is provided
 as Hash (i.e. to generate regex with name capturing groups), `:title` must
 contains the same keys as target

## Contributing

- Fork it
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
