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

* Param 1: torrent hash string, array of torrent hash strings
* Returns: array of torrent objects (objects include file_info data)

```
result = StrikeApi::Torrent.find(yourTorrentHash)
```

### Search

* Param 1: search phrase, example: "ubuntu iso"
* Returns: array of torrent objects

```
result = StrikeApi::Torrent.search(yourSearchPhrase)
```

* Param 1: search phrase, example: "ubuntu iso"
* Param 2: Category or sub category, examples: "Music", "Documentary"
* Returns: array of torrent objects

```
result = StrikeApi::Torrent.search(yourSearchPhrase, yourCatagoryOrSubCategory)
```

* Param 1: search phrase, example: "ubuntu iso"
* Param 2: Category, example: "Applications"
* Param 3: Sub category, example: "Windows"
* Returns: array of torrent objects

```
result = StrikeApi::Torrent.search(yourSearchPhrase, yourCatagory, yourSubCategory)
```

### Categories and sub categories

* Returns: array of valid categories

```
result = StrikeApi::Torrent.catagoriesAvailable()
```

* Returns: array of valid sub categories

```
result = StrikeApi::Torrent.subCatagoriesAvailable()
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
