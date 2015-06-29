module ApplicationHelper
	# determine class for bootstrap error messages
	def flash_class(level)
	  case level
	    when 'notice' then "alert alert-info"
	    when 'success' then "alert alert-success"
	    when 'error' then "alert alert-danger"
	    when 'alert' then "alert alert-warning"
	  end
	end

	def date_pretty(date)
		# format date: September 15, 2015
		date.strftime("%B %d, %Y")
	end

	def date_abbrev(date)
		# format date: 09-15-2015
		date.strftime("%m/%d/%y")
	end

	# NEED TO DETERMINE HOW BEST TO CACHE REQUESTS TO GOOGLE CLIENT
	# def google_api_client_cache
	# 	## Load cached discovered API, if it exists. This prevents retrieving the
	# 	## discovery document on every run, saving a round-trip to the discovery service.
	# 	if File.exists? CACHED_API_FILE
	# 		File.open(CACHED_API_FILE) do |file|
	# 			@service = Marshal.load(file)
	# 		end
	# 	else
	# 		@service = @client.discovered_api('calendar', 'v3')
	# 		File.open(CACHED_API_FILE, 'w') do |file|
	# 			Marshal.dump(@service, file)
	# 		end
	# 	end
	# end
end