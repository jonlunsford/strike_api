API_URL = 'https://getstrike.net/api/v2/torrents'

module StrikeAPI
  class Torrent
   attr_reader :hash, :title, :category, :subcategory, :seeds, :leeches, :file_count, :size, :download_count, :upload_date, :uploader_username, :magnet_uri, :file_info, :imdbid

    # Constructor for torrent objects
    def initialize(attributes)
      @hash = attributes['torrent_hash']
      @title = attributes['torrent_title']
      @imdbid = attributes['imdbid']
      @category = attributes['torrent_category']
      @subcategory = attributes['sub_category']
      @seeds = attributes['seeds']
      @leeches = attributes['leeches']
      @file_count = attributes['file_count']
      @size = attributes['size']
      # @download_count = attributes['download_count'] # Shown in API documentation, not implemented in the API.
      @upload_date = attributes['upload_date']
      @uploader_username = attributes['uploader_username']
      @magnet_uri = attributes['magnet_uri']
      # file info is only included in hash searches (the find method)
      if(attributes.has_key?('file_info'))
        file_names = attributes['file_info']['file_names'].to_a
        file_lengths = attributes['file_info']['file_lengths'].to_a
        @file_info = Array.new
        file_names.each_with_index do |item, i|
          @file_info[i] = [file_names[i],file_lengths[i]]
        end
      end
    end

    # Allows for both a single torrent_hash via a string and multiple via an array of torrent_hash strings.
    # Regardless of input, the output will be in the form of an array.
    def self.find(torrent_hash)
      hash_list_str = ''
      torrent_hash = Array(torrent_hash)
      if(torrent_hash.length > 50)
        raise 'Strike API accepts a maximum of 50 hashes per query'
      end
      torrent_hash.length.times do |i|
        hash_list_str += torrent_hash[i] + ','
      end
      url = "#{API_URL}/info/?hashes=#{hash_list_str}"
      response = HTTParty.get(URI.escape(url))
      error_checker(response)
      torrents_json = JSON.parse(response.body)
      torrents_json['torrents'].map { |attributes| new(attributes) }
    end

    def self.search(*input)
      case input.length
      when 1
        url = "#{API_URL}/search/?phrase=#{input[0]}"
      when 2
        if(category_checker(input[1]) == 'category') # second input is a category
          url = "#{API_URL}/search/?phrase=#{input[0]}&category=#{input[1]}"
        elsif(category_checker(input[1]) == 'subcategory') # second input is a sub category
          url = "#{API_URL}/search/?phrase=#{input[0]}&subcategory=#{input[1]}"
        else # second input is neither a category or sub category
          raise 'The category/subcategory entered is not valid'
        end
      when 3 # assumes order is input[0],category,subcategory
        if(category_checker(input[1]) != 'category')
          raise 'The category is not valid'
        elsif(category_checker(input[2]) != 'subcategory')
          raise 'The subcategory is not valid'
        end
        url = "#{API_URL}/search/?phrase=#{input[0]}&category=#{input[1]}&subcategory=#{input[2]}"
      else
        raise 'Invalid number of parameters: input <= 3'
      end
      response = HTTParty.get(URI.escape(url))
      error_checker(response)
      torrents_json = JSON.parse(response.body)
      torrents_json['torrents'].map { |attributes| new(attributes) }
    end

    def self.top(input)
      if((category_checker(input) != 'category') && input.strip.downcase != 'all') # all is also a valid top category
        raise 'The category is not valid'
      end
      url = "#{API_URL}/top/?category=#{input}"
      response = HTTParty.get(URI.escape(url))
      error_checker(response)
      torrents_json = JSON.parse(response.body)
      torrents_json['torrents'].map { |attributes| new(attributes) }
    end


    # Returns list of categories available
    def self.categories_available
      return ['Anime','Applications','Books','Games','Movies','Music','Other','TV','XXX']
    end

    # Returns list of sub categories available
    def self.subcategories_available
      return ['Highres Movies','Hentai','HD Video','Handheld','Games','Fiction','English-translated','Ebooks','Dubbed Movies','Documentary','Concerts','Comics','Books','Bollywood','Audio books','Asian','Anime Music Video','Animation','Android','Academic','AAC','3D Movies','XBOX360','Windows','Wii','Wallpapers','Video','Unsorted','UNIX','UltraHD','Tutorials','Transcode','Trailer','Textbooks','Subtitles','Soundtrack','Sound clips','Radio Shows','PSP','PS3','PS2','Poetry','Pictures','PC','Other XXX','Other TV','Other Music','Other Movies','Other Games','Other Books','Other Applications','Other Anime','Non-fiction','Newspapers','Music videos','Mp3','Movie clips','Magazines','Mac','Lossless','Linux','Karaoke','iOS']
    end

    def self.category_checker(str)
      downcased_categories = categories_available().map(&:downcase)
      downcased_subcategories = subcategories_available().map(&:downcase)
      if(downcased_categories.include? str.strip.downcase)
        return 'category'
      elsif(downcased_subcategories.include? str.strip.downcase)
        return 'subcategory'
      else
        return -1
      end
    end

    # Checks for 4XX errors and onward. Examples: 404, 502, 522
    def self.error_checker(response)
      code = response.code
      message = response.message
      if (valid_json?(response.body) && JSON.parse(response.body)['message'])
        message = JSON.parse(response.body)['message']
      end
      if(code >= 400)
        raise "Strike API error: #{code} - #{message}"
      end
    end

    # Checks for valid json
    def self.valid_json?(json)
      begin
        JSON.parse(json)
        return true
      rescue Exception => e
        return false
      end
    end

    private_class_method :error_checker, :category_checker, :valid_json?
  end
end
