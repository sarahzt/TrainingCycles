module CalendarsHelper
  	# getter method: find any calendars saved to current_user
  	def calendar
      # (use .pluck(:calendar_id) to return array of calendar_ids if needed)
      @calendar ||= current_user.training_cycles.last.calendar_id if current_user
  	end

  	# getter method: check to see if calendar function returns an object or nil
  	def has_calendar?
  		!calendar.nil?
  	end

	 # getter method: returns calendar_id
  	def calendar_id		
  		# calendar id returns nil if user doesn't exist
  		calendar unless !has_calendar? 
  	end  	
end