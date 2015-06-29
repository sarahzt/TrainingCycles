class EventsController < ApplicationController
    # before_action :access_token, only: [:index, :create]
    # before_action :calendar_id, only: [:index, :create]

    # def access_token
    #     @access_token = get_access_token
    # end

    # def calendar_id
    #     @calendar_id = get_calendar_id
    # end

    # do we need this?
    # def display_workout
    #     @calendar_id = get_calendar_id
    # end

    def index
        # if authenticated User has a calendar saved, retrieve it from Google
        # (How to cache these results so we don't have to keep connecting to Google???)
        if has_calendar?
            # create new api object
            client = Google::APIClient.new
            # pass in current_user's access_token
            client.authorization.access_token = access_token
            # set api to use
            service = client.discovered_api('calendar', 'v3')

            # make JSON call to Google (using Google API gem)
            @result = client.execute(
              :api_method => service.events.list,
              :parameters => {'calendarId' => calendar_id},
              :headers => {'Content-Type' => 'application/json'})

            # this is resulting executed JSON request:
            # Google::APIClient::Request Sending API request get https://www.googleapis.com/calendar/v3/calendars/ue6fl741kb3cegvkbrs6rhitc8@group.calendar.google.com/events {"User-Agent"=>"google-api-ruby-client/0.8.6 Microsoft Windows/6.1.7601 (gzip)", "Content-Type"=>"application/json", "Accept-Encoding"=>"gzip", "Authorization"=>"Bearer ya29.ggH27SOBZ6-JSvtg1ImK52DgNLnO32fgTyBOtO4bF420XMgTTFkw2bNAm2Jla47082C7vdgvY6cpWw", "Cache-Control"=>"no-store"}
        else
            render :html => "Sorry, you don't have a calendar. Redirect somewhere to add one."
            # redirect_to new_calendar_path
        end
    end

    def create
        # this is static - no user input yet
        # racedates can be Sunday or Saturday...race schedules usually start on Sunday or Monday?
        racedate = Date.parse("2015-11-29") # Sun, 29 Nov 2015
        plan_day = racedate - 18.weeks #  Sun, 26 Jul 2015

        # do i need to create some sort of google date object???

        # move this to application helper?
        # @workouts = Plan.find(1).workouts.includes(:workout_type).limit(2).order("plan_day")
        @workouts = Plan.find(1).workouts.includes(:workout_type).where("plan_day > 0").limit(1).order("plan_day")

        # what if i showed a blank calendar, then let user choose different race plans and see what they would look like on a calendar, would that work?

        # events seem to be based off of start/end dates, not an event/day id

        # how to save a bunch of workouts in a db, with no start or enddate saved, loop through and dynamically generate start and endates for them as they are inserted into calendar?

        # make user enter a race date, then backwards compute the first start date of the plan, then generate the event dates?

        # POST https://www.googleapis.com/calendar/v3/calendars/ue6fl741kb3cegvkbrs6rhitc8%40group.calendar.google.com/events?fields=description%2Csummary%2Cstart%2Cend&key={YOUR_API_KEY}

        client = Google::APIClient.new(
                :application_name => 'TrainingCycles',
                :application_version => '1.0.0')

        # set authorization and app to use
        client.authorization.access_token = access_token
        puts "***************"
        puts "access token:"
        puts access_token  
        puts "***************"
        
        service = client.discovered_api('calendar', 'v3')

        # instantiate new batch request
        batch = Google::APIClient::BatchRequest.new
        puts "***************"
        puts "batch client:"
        puts batch
        puts "***************"

        # ADDING MULTIPLE EVENTS: how to loop through and create new new_event objects?
        # how to calculate dates for objects? Is there an add_day function for date class? next_day(date) = date + 1

        # where would I get the training plan workout queries from?
        @workouts.each do |workout| 

            # create test event (this creates json object)
            # new_event.description = workout.description if !workout.description.nil?
            new_event = service.events.insert.request_schema.new
            new_event.summary = format_workout(workout.workout_type.name,workout.mileage,workout.description)
            new_event.start = { "date" => plan_day},
            new_event.end = { "date" => plan_day},
            
            # (Google Calendar API does not currently appear to enable setting free/busy option when inserting events. All events will be marked as busy, which is okay in the sense that we're saving these events to completely separate calendar as the users' primary calendar. See here: https://productforums.google.com/forum/#!topic/calendar/FGvvgTrhgEs)

            client.authorization = nil

            # add test event to calendar (google api expects json)
            @add_event = client.execute(
              :api_method => service.events.insert,
              :parameters => {'calendarId' => @calendar_id}, 
              :body_object => new_event,
              :headers => {'Content-Type' => 'application/json'}
            )

            # batch is currently undefined
             # callback
            # batch = Google::APIClient::BatchRequest.new do |result|
            #   puts result.data
            # end

            # batch.add(
            #   :api_method => service.events.insert,
            #   :parameters => {'calendarId' => @calendar_id}, 
            #   :body_object => new_event,
            #   :headers => {'Content-Type' => 'application/json'}
            # )  do |result|
            #     # this is a callback - output only occurs when client.execute runs
            #     puts "***************"
            #     puts "batch results:"
            #     puts result.data
            #     puts "***************"
            # end

            # advance date to next day (easier way to do this?)
            plan_day += 1
            puts plan_day.to_s
           
            # add event to batch
            # batch.add(add_event)
        end

        # bug workaround - need to add this to prevent batch client from sending authorization headers, which causes 'missing access token' error, instead of relying on api key
        #client.authorization = nil

        # this is outside database output
        #client.execute(batch)

        render :html => "batch successful"
    end

    def edit
    end

    def update
    end

    def show
        # if authenticated User has a calendar saved, retrieve it from Google
        # (How to cache these results so we don't have to keep connecting to Google???)
        if has_calendar?
            # create new api object
            client = Google::APIClient.new
            # pass in current_user's access_token
            client.authorization.access_token = access_token
            # set api to use
            service = client.discovered_api('calendar', 'v3')

            # make JSON call to Google (using Google API gem)
            @result = client.execute(
              :api_method => service.events.get,
              :parameters => {
                'calendarId' => calendar_id,
                'eventId' => params[:id]},
              :headers => {'Content-Type' => 'application/json'})

            # this is resulting executed JSON request:
            # Google::APIClient::Request Sending API request get https://www.googleapis.com/calendar/v3/calendars/ue6fl741kb3cegvkbrs6rhitc8@group.calendar.google.com/events {"User-Agent"=>"google-api-ruby-client/0.8.6 Microsoft Windows/6.1.7601 (gzip)", "Content-Type"=>"application/json", "Accept-Encoding"=>"gzip", "Authorization"=>"Bearer ya29.ggH27SOBZ6-JSvtg1ImK52DgNLnO32fgTyBOtO4bF420XMgTTFkw2bNAm2Jla47082C7vdgvY6cpWw", "Cache-Control"=>"no-store"}
        else
            render :html => "Sorry, you don't have a calendar. Redirect somewhere to add one."
            # redirect_to new_calendar_path
        end
    end

    def destroy
    end
end
