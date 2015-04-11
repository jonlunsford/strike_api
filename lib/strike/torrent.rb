require 'httparty'
require 'json'

API_URL = "https://getstrike.net/api/v2/torrents"

module Strike
	class Torrent
		attr_reader :hash, :title, :category, :sub_category, :seeds, :leeches, :file_count, :size, :download_count, :upload_date, :uploader_username, :magnet_uri
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
		end

	  	def self.find(torrentHash)
  			hashListStr = ""
  			torrentHash = Array(torrentHash)
  			torrentHash.length.times do |i|
  				hashListStr = hashListStr + torrentHash[i] + ","
  			end
			response =  HTTParty.get("#{API_URL}/info/?hashes=#{hashListStr}")
			errorChecker(response)
    		torrentsJSON = JSON.parse(response.body)
      		torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    def self.search(input)
	    	input = CGI::escape(input)
	      	response = HTTParty.get("#{API_URL}/search/?phrase=#{input}")
	      	errorChecker(response)
	      	torrentsJSON = JSON.parse(response.body)
	      	torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    	def self.searchCat(input, category)
	    	input = CGI::escape(input)
	      	response = HTTParty.get("#{API_URL}/search/?phrase=#{input}&category=#{category}")
	      	errorChecker(response)
	      	torrentsJSON = JSON.parse(response.body)
	      	torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

			def self.searchSubCat(input,sub_category)
	    	input = CGI::escape(input)
	      	response = HTTParty.get("#{API_URL}/search/?phrase=#{input}&subcategory=#{sub_category}")
	      	errorChecker(response)
	      	torrentsJSON = JSON.parse(response.body)
	      	torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    	def self.searchCatSubCat(input, category, sub_category)
	    	input = CGI::escape(input)
	      	response = HTTParty.get("#{API_URL}/search/?phrase=#{input}&category=#{category}&subcategory=#{sub_category}")
	      	errorChecker(response)
	      	torrentsJSON = JSON.parse(response.body)
	      	torrentsJSON["torrents"].map { |attributes| new(attributes) }
	    end

	    def self.catagoriesAvailable
	    	return ["Anime","Applications","Books","Games","Movies","Music","Other","TV","XXX"]
	    end

	    def self.subCatagoriesAvailable
	    	return ["Highres Movies","Hentai","HD Video","Handheld","Games","Fiction","English-translated","Ebooks","Dubbed Movies","Documentary","Concerts","Comics","Books","Bollywood","Audio books","Asian","Anime Music Video","Animation","Android","Academic","AAC","3D Movies","XBOX360","Windows","Wii","Wallpapers","Video","Unsorted","UNIX","UltraHD","Tutorials","Transcode","Trailer","Textbooks","Subtitles","Soundtrack","Sound clips","Radio Shows","PSP","PS3","PS2","Poetry","Pictures","PC","Other XXX","Other TV","Other Music","Other Movies","Other Games","Other Books","Other Applications","Other Anime","Non-fiction","Newspapers","Music videos","Mp3","Movie clips","Magazines","Mac","Lossless","Linux","Karaoke","iOS"]
	    end

	    def self.errorChecker(response)
	    	code = response.code
	    	message = JSON.parse(response.body)["message"]
	    	if(code >= 400)
	    		raise "Strike API error: #{code} - #{message}"
	    	end
	    end
	   	private_class_method :errorChecker
	end
end
