# Gastly

[![Gem Version](https://badge.fury.io/rb/gastly.svg)](http://badge.fury.io/rb/gastly)
[![Dependency Status](https://gemnasium.com/mgrachev/gastly.svg)](https://gemnasium.com/mgrachev/gastly)
[![Code Climate](https://codeclimate.com/github/mgrachev/gastly/badges/gpa.svg)](https://codeclimate.com/github/mgrachev/gastly)
[![Build Status](https://travis-ci.org/mgrachev/gastly.svg?branch=master)](https://travis-ci.org/mgrachev/gastly)
[![Coverage Status](https://coveralls.io/repos/github/mgrachev/gastly/badge.svg?branch=master)](https://coveralls.io/github/mgrachev/gastly?branch=master)

Create screenshots or previews of web pages using Gastly. Under the hood [Phantom.js](https://github.com/ariya/phantomjs/) and [MiniMagick](https://github.com/minimagick/minimagick). Gastly, I choose you!

![Gastly](https://github.com/mgrachev/gastly/raw/master/gastly.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gastly'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gastly

## Usage

```ruby
Gastly.capture('http://google.com', 'output.png')
```

It is also possible to further customize the creation of screenshots and further processing of the resulting image:

```ruby
screenshot = Gastly.screenshot('http://google.com')
screenshot.selector = '#hplogo' # By default, the full screen is captured
screenshot.browser_width = 1280 # Default: 1440px
screenshot.browser_height = 780 # Default: 900px
screenshot.timeout = 1000 # Default: 0 seconds
screenshot.cookies = { user_id: 1, auth_token: 'abcd' } # If you need
screenshot.proxy_host = '10.10.10.1' # If you want to use a http proxy
screenshot.proxy_port = '8080'
screenshot.phantomjs_options = '--ignore-ssl-errors=true'
image = screenshot.capture
```

Or

```ruby
screenshot = Gastly.screenshot('http://google.com', selector: '#hplogo', timeout: 1000)
image = screenshot.capture
```

You can resize or change the format of the screenshot:

```ruby
image = screenshot.capture
image.resize(width: 110, height: 110) # Creates a previews of web-page
image.format('png')
image.save('output.png')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/mgrachev/gastly/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
