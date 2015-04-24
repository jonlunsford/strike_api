require 'httparty'
require 'json'
require 'cgi'

API_URL = "https://getstrike.net/api/v2/torrents"

module StrikeApi
	class Torrent
		attr_reader :hash, :title, :category, :sub_category, :seeds, :leeches, :file_count, :size, :download_count, :upload_date, :uploader_username, :magnet_uri, :file_info

		# Constructor for torrent objects
	    def initialize(attributes)
		    @hash = attributes["torrent_hash"]
		    @title = attributes["torrent_title"]
		    @category = attributes["torrent_category"]
		    @sub_category = attributes["sub_category"]
		    @seeds = attributes["seeds"]
		    @leeches = attributes["leeches"]
		    @file_count = attributes["file_count"]
			@size = attributes["size"]
			# @download_count = attributes["download_count"] # Shown in documentation, not implemented in the API.
		    @upload_date = attributes["upload_date"]
		    @uploader_username = attributes["uploader_username"]
		    @magnet_uri = attributes["magnet_uri"]
		    if(attributes.has_key?("file_info")) # file info is only included in hash searches (the find method)
		    	file_names = attributes["file_info"]["file_names"].to_a
		    	file_lengths = attributes["file_info"]["file_lengths"].to_a
		    	@file_info = Array.new
		    	file_names.each_with_index do |item, i|
		    		@file_info[i] = [file_names[i],file_lengths[i]]
		    	end
		    end
		end

		# Allows for both a single torrentHash via a string and multiple via an array of torrentHash strings.
		# Regardless of input, the output will be in the form of an array.
	  	def self.find(torrentHash)
  			hashListStr = ""
  			torrentHash = Array(torrentHash)
  			if(torrentHash.length > 50)
  				raise "Strike API accepts a maximum of 50 hashes per query"
  			end
  			torrentHash.length.times do |i|
  				hashListStr += torrentHash[i] + ","
  			end
			response =  HTTParty.get("#{API_URL}/info/?hashes=#{hashListStr}")
			errorChecker(response)
    		torrentsJSON = JSON.parse(response.body)
      		torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    def self.search(*input)
	    	searchPhrase = CGI::escape(input[0].strip)
	    	case input.length
	    	when 1
	    		response = HTTParty.get("#{API_URL}/search/?phrase=#{searchPhrase}")
	    	when 2
	    		if(categoryChecker(input[1]) == "category") # second input is a category
	    			response = HTTParty.get("#{API_URL}/search/?phrase=#{searchPhrase}&category=#{input[1]}")
	    		elsif(categoryChecker(input[1]) == "subCategory") # second input is a sub category
	    			response = HTTParty.get("#{API_URL}/search/?phrase=#{searchPhrase}&subcategory=#{input[1]}")
	    		else # second input is neither a category or sub category
	    			raise "The category/sub category entered is not valid"
	    		end
	    	when 3 # assumes order is searchPhrase,category,subCategory
	    		if(categoryChecker(input[1]) != "category")
	    			raise "The category is not valid"
	    		elsif(categoryChecker(input[2]) != "subCategory")
	    			raise "The sub category is not valid"
	    		end
	    		response = HTTParty.get("#{API_URL}/search/?phrase=#{searchPhrase}&category=#{input[1]}&subcategory=#{input[2]}")
	    	else
	    		raise "Invalid number of parameters: input <= 3"
	    	end
	      	errorChecker(response)
	      	torrentsJSON = JSON.parse(response.body)
	      	torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    def self.top(input)
	    	searchPhrase = CGI::escape(input.strip)
			if((categoryChecker(input) != "category") && input.strip.downcase != "all") # all is also a valid top category
	   			raise "The category is not valid"
	   		end
			response = HTTParty.get("#{API_URL}/top/?category=#{input}")
			errorChecker(response)
	      	torrentsJSON = JSON.parse(response.body)
	      	torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    # Returns list of categories available
	    def self.catagoriesAvailable
	    	return ["Anime","Applications","Books","Games","Movies","Music","Other","TV","XXX"]
	    end

	    # Returns list of sub categories available
	    def self.subCatagoriesAvailable
	    	return ["Highres Movies","Hentai","HD Video","Handheld","Games","Fiction","English-translated","Ebooks","Dubbed Movies","Documentary","Concerts","Comics","Books","Bollywood","Audio books","Asian","Anime Music Video","Animation","Android","Academic","AAC","3D Movies","XBOX360","Windows","Wii","Wallpapers","Video","Unsorted","UNIX","UltraHD","Tutorials","Transcode","Trailer","Textbooks","Subtitles","Soundtrack","Sound clips","Radio Shows","PSP","PS3","PS2","Poetry","Pictures","PC","Other XXX","Other TV","Other Music","Other Movies","Other Games","Other Books","Other Applications","Other Anime","Non-fiction","Newspapers","Music videos","Mp3","Movie clips","Magazines","Mac","Lossless","Linux","Karaoke","iOS"]
	    end

	    def self.categoryChecker(str)
	    	downcasedCategories = catagoriesAvailable().map(&:downcase)
	    	downcasedSubCategories = subCatagoriesAvailable().map(&:downcase)
	    	if(downcasedCategories.include? str.strip.downcase)
	    		return "category"
	    	elsif(downcasedSubCategories.include? str.strip.downcase)
	    		return "subCategory"
	    	else
	    		return -1
	    	end
	    end
	    # Checks for 4XX errors and onward. Examples: 404, 502
	    def self.errorChecker(response)
	    	code = response.code
	    	message = JSON.parse(response.body)["message"]
	    	if(code >= 400)
	    		raise "Strike API error: #{code} - #{message}"
	    	end
	    end
	   	private_class_method :errorChecker, :categoryChecker
	end
end
