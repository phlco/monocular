# Monocular

Annotate's Gemfiles with Gem descriptions or summaries

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monocular'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install monocular
```

## Usage

```bash
# In the same directory as a Gemfile
$ monocular
```

### Example Output

```ruby
# XPath is a Ruby DSL for generating XPath expressions
gem 'xpath'

# Clean ruby syntax for writing and deploying cron jobs.
gem 'whenever', :require => false

# Quickly setup backbone.js for use with rails 3.1. Generators are provided to quickly
# get started.
gem 'rails-backbone'
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/monocular/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
