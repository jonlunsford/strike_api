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
torrentInfoArray = StrikeApi::Torrent.find(yourTorrentHash)
```

### Search

```ruby
# Param 1: search phrase, example: "ubuntu iso"
# Returns: array of torrent objects
searchResults = StrikeApi::Torrent.search(yourSearchPhrase)

# Param 1: search phrase, example: "ubuntu iso"
# Param 2: category or sub category, examples: "Music", "Documentary"
# Returns: array of torrent objects
searchResults = StrikeApi::Torrent.search(yourSearchPhrase, yourCatagoryOrSubCategory)

# Param 1: search phrase, example: "ubuntu iso"
# Param 2: category, example: "Applications"
# Param 3: sub category, example: "Windows"
# Returns: array of torrent objects
searchResults = StrikeApi::Torrent.search(yourSearchPhrase, yourCatagory, yourSubCategory)
```

### Top Torrents

```ruby
# Param 1: category, examples: "Books", "all"
# Returns: top 100 torrents
topResults = StrikeApi::Torrent.top(yourCatagory)
```

### Categories and sub categories

```ruby
# Returns: array of valid categories
categoryArray = StrikeApi::Torrent.catagoriesAvailable()

# Returns: array of valid sub categories
subCategoryArray = StrikeApi::Torrent.subCatagoriesAvailable()
```

See tests for more usage examples.

## TODO

1. Better commenting
2. ~~Provide usage examples in readme~~

## Contributing

1. Fork it ( https://github.com/marshallford/strike_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
