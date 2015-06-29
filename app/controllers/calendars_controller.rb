class CalendarsController < ApplicationController
	before_action :authenticate, :google_authenticate

	def authenticate
      deny_access unless signed_in?
    end

    def google_authenticate
      google_deny_access unless google_signed_in?
    end

	def index				
		# if authenticated User has a calendar saved, retrieve it from Google
		if has_calendar?
			# create new api object
			# (think there's a way to cache/remember this api call so that we're not constantly reconnecting to Google)
			client = Google::APIClient.new
			# pass in current_user's access_token
		    client.authorization.access_token = access_token
		    # set api to use
		    service = client.discovered_api('calendar', 'v3')
		   	# service = google_api_client_cache

		    # make JSON call to Google (using Google API gem)
		    @result = client.execute(
		      :api_method => service.calendar_list.get,
		      :parameters => {'calendarId' => calendar_id},
		      :headers => {'Content-Type' => 'application/json'})

		    # this is resulting executed JSON request:
			# Google::APIClient::Request Sending API request get https://www.googleapis.com/calendar/v3/calendars/ue6fl741kb3cegvkbrs6rhitc8@group.calendar.google.com {"User-Agent"=>"google-api-ruby-client/0.8.6 Microsoft Windows/6.1.7601 (gzip)", "Content-Type"=>"application/json", "Accept-Encoding"=>"gzip", "Authorization"=>"Bearer ya29.ggFbbU1H3aTK2THOvWoOKukuhNVchno3OFn6PG-mzM1k2NySyNTm8U19OxDmwAgZ93Rez9fusoZ7Aw", "Cache-Control"=>"no-store"}
		else
			flash[:error] = "You need to create a Training Cycles calendar first"
			redirect_to new_calendar_path
		end
	end

	def new
		# need to Oauth login here?
	end

	def create
		# ADD NEW CALENDAR:

		# render :html => "in create calendars method"
		# do i need to set timeZone parameter, or will it default to user's time zone
		client = Google::APIClient.new(
		    :application_name => 'TrainingCycles',
		    :application_version => '1.0.0')

	    client.authorization.access_token = access_token
	    service = client.discovered_api('calendar', 'v3')

	    new_calendar = service.calendars.insert.request_schema.new
		new_calendar.description = "Training plan for my upcoming race"
		new_calendar.summary = "TrainingCycles"
		# new_calendar.visibility = "private"

		# originally tried passing in summary and description as parameters hash as I saw in other examples, but received an error that title was missing; api wants a body_object instead
		result = client.execute(
	      :api_method => service.calendars.insert,
	      :parameters => { 'calendarId' => 'secondary'}, 
	      :body_object => new_calendar,
	      :headers => {'Content-Type' => 'application/json'})

		# console log any errors (put appropriate redirects in here, saving errors to Flash)		
		# (this is a callback - output only occurs when client.execute runs)
		if result.status == 200
		    puts "***************"
		    puts "calendar created - calendar id: #{result.data.id}"
		    puts "***************"
		elsif result.status >= 400
		    puts "Error code: #{result.data['error']['code']}"
		    puts "Error message: #{result.data['error']['message']}"
		    # More error information can be retrieved with result.data['error']['errors'].
		end

		# save the id of the calendar in database in a user/account table. for now, save to session
		# ideally, update TrainingCycles table with calendar id (record should already exist now)
		# session[:calendar_id] = @result.data.id
		# update training cycle with calendar id 
		# (user can have many training_cycles; 'last' tells db which record)
		current_user.training_cycles.last.update(calendar_id:result.data.id)

        # now that we created calendar, populate it with events
		# render :html => 'just created calendar (or not - check the console)'
		redirect_to create_event_path		
	end
end