class EventsController < ApplicationController
    def create
        # this is static - no user input yet
        # racedates can be Sunday or Saturday...race schedules usually start on Sunday or Monday?
        racedate = Date.parse("2015-11-29") # Sun, 29 Nov 2015
        plan_day = racedate - 18.weeks #  Sun, 26 Jul 2015

        # do i need to create some sort of google date object???

        # (move this to application helper?)
        @workouts = Plan.find(1).workouts.includes(:workout_type).where("plan_day > 0").limit(5).order("plan_day")

        # POST https://www.googleapis.com/calendar/v3/calendars/ue6fl741kb3cegvkbrs6rhitc8%40group.calendar.google.com/events?fields=description%2Csummary%2Cstart%2Cend&key={YOUR_API_KEY}

        client = Google::APIClient.new(
                :application_name => 'TrainingCycles',
                :application_version => '1.0.0')

        # set authorization and app to use
        service = client.discovered_api('calendar', 'v3')

        # instantiate new batch request
        batch = Google::APIClient::BatchRequest.new
        puts "***************"
        puts "batch client:"
        puts batch
        puts "***************"

        # provide google auth token
        client.authorization.access_token = access_token

        puts "****************"
        puts "access token:"
        puts access_token
        puts "****************"

        @workouts.each do |workout| 

            # create test event (this creates json object)
            new_event = service.events.insert.request_schema.new
            new_event.description = workout.description if !workout.description.nil?
            new_event.summary = workout.workout_type.name + " :" workout.mileage + " mi."
            new_event.start = {"date" => plan_day}
            new_event.end = {"date" => plan_day}

            # (Google Calendar API does not currently appear to enable setting free/busy option when inserting events. All events will be marked as busy, which is okay in the sense that we're saving these events to completely separate calendar as the users' primary calendar. See here: https://productforums.google.com/forum/#!topic/calendar/FGvvgTrhgEs)

            # add test event to calendar (google api expects json)
            # client.execute(
            #   :api_method => service.events.insert,
            #   :parameters => {'calendarId' => calendar_id}, 
            #   :body_object => new_event,
            #   :headers => {'Content-Type' => 'application/json'})

            batch.add(
              :api_method => service.events.insert,
              :parameters => {'calendarId' => calendar_id}, 
              :body_object => new_event,
              :headers => {'Content-Type' => 'application/json'}
            )  do |result|
                # this is a callback - output only occurs when client.execute runs
                puts "***************"
                puts "batch results:"
                puts result.data
                puts "***************"
            end

            # advance date to next day (easier way to do this?)
            plan_day += 1
            puts plan_day.to_s
        end

        # bug workaround - need to add this to prevent batch client from sending authorization headers, which causes 'missing access token' error, instead of relying on api key
        #client.authorization = nil

        # this is outside database output
        client.execute(batch)
        
        render :html => "all good"
    end

    def edit
    end

    def update
    end

    def show
        # manual dates are for dev only
        # racedates can be Sunday or Saturday...race schedules usually start on Sunday or Monday?
        @racedate = Date.parse("2015-11-29") # Sun, 29 Nov 2015
        @week1 = racedate - 18.weeks #  Sun, 26 Jul 2015

        # account for if user picks a race date that's sooner than the training length
        if Date.today > @week1
            @week1 = Date.today
        end
    end

    def destroy
    end
end
