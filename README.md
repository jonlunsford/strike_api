# Strike API

API wrapper for the Strike Search website (http://getstrike.net)

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
Use the find method to find information on a specific torrent hash. The find method accepts both a single string and an array of strings.

```
result = StrikeApi::Torrent.find(yourTorrentHash)
```

Use the search method with one parameter to search for a torrent by title. 

```
result = StrikeApi::Torrent.search(yourSearchPhrase)
```

Use the search method with two parameters, the first being your search phrase and the second being either a category or a sub category.

```
result = StrikeApi::Torrent.search(yourSearchPhrase, yourCatagoryOrSubCategory) 
```

Use the search method with three parameters, the first being your search phrase, second being a category, and third being a sub category.

```
result = StrikeApi::Torrent.search(yourSearchPhrase, yourCatagory, yourSubCategory)
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
