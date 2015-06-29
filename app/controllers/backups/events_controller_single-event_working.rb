class EventsController < ApplicationController
    # before_action :access_token, only: [:index, :create]
    # before_action :calendar_id, only: [:index, :create]

    # def access_token
    #     @access_token = get_access_token
    # end

    # def calendar_id
    #     @calendar_id = get_calendar_id
    # end

    def create

        # what if i showed a blank calendar, then let user choose different race plans and see what they would look like on a calendar, would that work?

        # events seem to be based off of start/end dates, not an event/day id

        # how to save a bunch of workouts in a db, with no start or enddate saved, loop through and dynamically generate start and endates for them as they are inserted into calendar?

        # make user enter a race date, then backwards compute the first start date of the plan, then generate the event dates?

        # POST https://www.googleapis.com/calendar/v3/calendars/ue6fl741kb3cegvkbrs6rhitc8%40group.calendar.google.com/events?fields=description%2Csummary%2Cstart%2Cend&key={YOUR_API_KEY}

        client = Google::APIClient.new(
                :application_name => 'TrainingCycles',
                :application_version => '1.0.0')

        # set authorization and app to use
        service = client.discovered_api('calendar', 'v3')

        # provide google auth token
        client.authorization.access_token = access_token

        puts "****************"
        puts "access token:"
        puts access_token
        puts "****************"

        # create test event (this creates json object)
        new_event = service.events.insert.request_schema.new
        new_event.description = "Training Cycles Workout"
        new_event.summary = "Easy Run: 6 miles"
        new_event.start = { "date" => "2015-06-01"}
        new_event.end = { "date" => "2015-06-01"}
        
        # (Google Calendar API does not currently appear to enable setting free/busy option when inserting events. All events will be marked as busy, which is okay in the sense that we're saving these events to completely separate calendar as the users' primary calendar. See here: https://productforums.google.com/forum/#!topic/calendar/FGvvgTrhgEs)

        # add test event to calendar (google api expects json)
        client.execute(
          :api_method => service.events.insert,
          :parameters => {'calendarId' => calendar_id}, 
          :body_object => new_event,
          :headers => {'Content-Type' => 'application/json'})

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
