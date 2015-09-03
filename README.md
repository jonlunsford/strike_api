# Strike API

[![Gem Version](https://img.shields.io/gem/v/strike_api.svg)](https://rubygems.org/gems/strike_api)

API wrapper for the Strike Search website (https://getstrike.net/torrents/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strike_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strike_api

## Usage

### Find

```ruby
# Param 1: torrent hash string or array of torrent hash strings
# Returns: array of torrent objects (objects include file_info data)
torrent_info_Array = StrikeAPI::Torrent.find(yourTorrentHash)
```

### Search

```ruby
# Param 1: search phrase, example: "ubuntu iso"
# Returns: array of torrent objects
search_results = StrikeAPI::Torrent.search(search_phrase)

# Param 1: search phrase, example: "ubuntu iso"
# Param 2: category or subcategory, examples: "Music", "Documentary"
# Returns: array of torrent objects
search_results = StrikeAPI::Torrent.search(search_phrase, category_or_subcategory)

# Param 1: search phrase, example: "ubuntu iso"
# Param 2: category, example: "Applications"
# Param 3: subcategory, example: "Windows"
# Returns: array of torrent objects
search_results = StrikeAPI::Torrent.search(search_phrase, category, subcategory)
```

### Top torrents

```ruby
# Param 1: category, examples: "Books", "all"
# Returns: top 100 torrents
top_results = StrikeAPI::Torrent.top(category)
```

### Categories and sub categories

```ruby
# Returns: array of valid categories
category_array = StrikeAPI::Torrent.categories_available()

# Returns: array of valid subcategories
subcategory_array = StrikeAPI::Torrent.subcategories_available()
```

See tests for more usage examples.

## TODO

1. Better commenting
2. ~~Provide usage examples in readme~~

## Testing

```
rake test
```

## Contributing

1. Fork it ( https://github.com/marshallford/strike_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
