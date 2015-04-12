require './test/test_helper'

class StrikeTorrentTest < Minitest::Test

	def test_exists
   		assert StrikeApi::Torrent
  	end

  	def test_find_single_torrent
	   	VCR.use_cassette('test_find_single_torrent') do
	    	result = StrikeApi::Torrent.find("156B69B8643BD11849A5D8F2122E13FBB61BD041")[0]
			assert_equal StrikeApi::Torrent, result.class
			assert_equal "156B69B8643BD11849A5D8F2122E13FBB61BD041", result.hash
			assert_equal "Slackware 14.1 x86_64 DVD ISO", result.title
			assert_equal "Applications", result.category
			assert_equal "", result.sub_category
			assert_equal 192, result.seeds
			assert_equal 9, result.leeches
			assert_equal 4, result.file_count
			assert_equal 2437393940, result.size
			# assert_equal 40, result.download_count
			assert_equal "Feb 24, 2014", result.upload_date
			assert_equal "Nusantara", result.uploader_username
			assert_equal "magnet:?xt=urn:btih:156B69B8643BD11849A5D8F2122E13FBB61BD041&dn=Slackware+14.1+x86_64+DVD+ISO&tr=udp:\/\/open.demonii.com:1337&tr=udp:\/\/tracker.coppersurfer.tk:6969&tr=udp:\/\/tracker.leechers-paradise.org:6969&tr=udp:\/\/exodus.desync.com:6969", result.magnet_uri
	    end
	end

	def test_find_array
	   	VCR.use_cassette('test_find_array') do
	    	result = StrikeApi::Torrent.find(["156B69B8643BD11849A5D8F2122E13FBB61BD041","B425907E5755031BDA4A8D1B6DCCACA97DA14C04"])
	    	result1 = result[0]
	    	result2 = result[1]
	    	# Torrent 1: Slackware ISO
			assert_equal StrikeApi::Torrent, result1.class
			assert_equal "156B69B8643BD11849A5D8F2122E13FBB61BD041", result1.hash
			assert_equal "Slackware 14.1 x86_64 DVD ISO", result1.title
			assert_equal "Applications", result1.category
			assert_equal "", result1.sub_category
			assert_equal 192, result1.seeds
			assert_equal 9, result1.leeches
			assert_equal 4, result1.file_count
			assert_equal 2437393940, result1.size
			# assert_equal 40, result1.download_count
			assert_equal "Feb 24, 2014", result1.upload_date
			assert_equal "Nusantara", result1.uploader_username
			assert_equal "magnet:?xt=urn:btih:156B69B8643BD11849A5D8F2122E13FBB61BD041&dn=Slackware+14.1+x86_64+DVD+ISO&tr=udp:\/\/open.demonii.com:1337&tr=udp:\/\/tracker.coppersurfer.tk:6969&tr=udp:\/\/tracker.leechers-paradise.org:6969&tr=udp:\/\/exodus.desync.com:6969", result1.magnet_uri
			# Torrent 2: Arch ISO
			assert_equal StrikeApi::Torrent, result2.class
			assert_equal "B425907E5755031BDA4A8D1B6DCCACA97DA14C04", result2.hash
			assert_equal "Arch Linux 2015.01.01 (x86\/x64)", result2.title
			assert_equal "Applications", result2.category
			assert_equal "", result2.sub_category
			assert_equal 645, result2.seeds
			assert_equal 13, result2.leeches
			assert_equal 1, result2.file_count
			assert_equal 615514112, result2.size
			# assert_equal 40, result2.download_count
			assert_equal "Jan  6, 2015", result2.upload_date
			assert_equal "The_Doctor-", result2.uploader_username
			assert_equal "magnet:?xt=urn:btih:B425907E5755031BDA4A8D1B6DCCACA97DA14C04&dn=Arch+Linux+2015.01.01+%28x86%2Fx64%29&tr=udp:\/\/open.demonii.com:1337&tr=udp:\/\/tracker.coppersurfer.tk:6969&tr=udp:\/\/tracker.leechers-paradise.org:6969&tr=udp:\/\/exodus.desync.com:6969", result2.magnet_uri
	    end
	end

  	def test_find_no_torrents
   		VCR.use_cassette('test_find_no_torrents') do
   			begin
   				result = StrikeApi::Torrent.find("156B69B8643BD1184D041")[0]
   			rescue => e
   				assert_equal "Strike API error: 404 - No torrents found with provided hashes", e.message
   			end
    	end
	end

	def test_find_empty
   		VCR.use_cassette('test_find_empty') do
   			begin
   				result = StrikeApi::Torrent.find("")[0]
   			rescue => e
   				assert_equal "Strike API error: 404 - No torrents found with provided hashes", e.message
   			end
    	end
	end

	def test_search_no_torrents
   		VCR.use_cassette('test_search_no_torrents') do
   			begin
   				result = StrikeApi::Torrent.search("123456789abcdefg")[0]
   			rescue => e
   				assert_equal "Strike API error: 404 - No torrents found.", e.message
   			end
    	end
	end

	def test_search_empty
   		VCR.use_cassette('test_search_empty') do
   			begin
   				result = StrikeApi::Torrent.search("")[0]
   			rescue => e
   				assert_equal "Strike API error: 404 - Please enter a phrease.", e.message
   			end
    	end
	end

    def test_search
	    VCR.use_cassette('test_search') do
	    	result = StrikeApi::Torrent.search("Slackware 14.1 x86_64 DVD ISO")
	      	assert_equal 1, result.length
	      	assert result.kind_of?(Array)
	      	assert result.first.kind_of?(StrikeApi::Torrent)
	    end
  	end

	def test_search_category
	    VCR.use_cassette('test_search_category') do
	    	result = StrikeApi::Torrent.search("windows", "Applications")
	      	assert_equal 100, result.length
	      	assert result.kind_of?(Array)
	      	assert result.first.kind_of?(StrikeApi::Torrent)
	    end
  	end

  	def test_search_subCategory
	    VCR.use_cassette('test_search_subCategory') do
	    	result = StrikeApi::Torrent.search("windows", "Windows")
	      	assert_equal 100, result.length
	      	assert result.kind_of?(Array)
	      	assert result.first.kind_of?(StrikeApi::Torrent)
	    end
  	end

  	def test_search_category_subCategory
	    VCR.use_cassette('test_search_category_subCategory') do
	    	result = StrikeApi::Torrent.search("windows", "Applications", "Windows")
	      	assert_equal 100, result.length
	      	assert result.kind_of?(Array)
	      	assert result.first.kind_of?(StrikeApi::Torrent)
	    end
  	end

  	def test_search_more_than_three_params
	    VCR.use_cassette('test_search_more_than_three_params') do
	      	begin
   				result = StrikeApi::Torrent.search("windows", "Applications", "Windows","Test")
   			rescue => e
   				assert_equal "Invalid number of parameters: input <= 3", e.message
   			end
	    end
  	end

  	def test_search_invalid_two_inputs
	    VCR.use_cassette('test_search_invalid_two_inputs') do
	      	begin
   				result = StrikeApi::Torrent.search("windows", "asdasdasd")
   			rescue => e
   				assert_equal "The category/sub category entered is not valid", e.message
   			end
	    end
  	end

  	def test_search_invalid_category
	    VCR.use_cassette('test_search_invalid_category') do
	      	begin
   				result = StrikeApi::Torrent.search("windows", "asdasdasd","Windows")
   			rescue => e
   				assert_equal "The category is not valid", e.message
   			end
	    end
  	end

  	def test_search_invalid_subcategory
	    VCR.use_cassette('test_search_invalid_subcategory') do
	      	begin
   				result = StrikeApi::Torrent.search("windows", "Applications","asdasdsdsa")
   			rescue => e
   				assert_equal "The sub category is not valid", e.message
   			end
	    end
  	end

	def test_catagoriesAvailable
		result = StrikeApi::Torrent.catagoriesAvailable
	    assert result.kind_of?(Array)
	    assert result.first.kind_of?(String)
	end

	def test_subCatagoriesAvailable
		result = StrikeApi::Torrent.subCatagoriesAvailable
	    assert result.kind_of?(Array)
	    assert result.first.kind_of?(String)
	end
end
