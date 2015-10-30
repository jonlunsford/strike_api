module StrikeAPI
  class Media
    include StrikeAPI::Utils

    API_URL = 'https://getstrike.net/api/v2/media'

    def initialize(attributes)
      attributes.each do |key, val|
        self.class.__send__(:attr_accessor, "#{key.downcase}")
        self.instance_variable_set("@#{key.downcase}", val)
      end
    end

    def self.imdb(id)
      url = "#{API_URL}/imdb/?imdbid=#{id}"
      response = HTTParty.get(URI.escape(url))
      torrent = JSON.parse(response.body)
      new(torrent)
    end
  end
end
