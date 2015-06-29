class EventsController < ApplicationController
    before_action :authenticate, :google_authenticate

    def authenticate
      deny_access unless signed_in?
    end

    def google_authenticate
      google_deny_access unless google_signed_in?
    end

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
            flash[:error] = "You need to create a Training Cycles calendar first"
            redirect_to new_calendar_path
        end
    end

    def create
        # look up user training cycle info
        training_cycle = current_user.training_cycles.last        

        # lookup date of target race
        race_date = training_cycle.race_date

        puts "****************"
        puts "race_date:"
        puts race_date
        puts "****************"

        # lookup all (actual) workouts for selected plan
        @workouts = training_cycle.plan.workouts.includes(:workout_type).where("plan_day > 0").order("plan_day")

        puts "****************"
        puts "number of workouts:"
        puts @workouts.count 
        puts "****************"
     
        # determine date of first workout in plan based on number of days in plan
        # (don't think we need this plan helper when we can use workouts.count instead - 
        # actually, we do need it - it tweaks the start date for us)
        plan_day = first_date_of_plan(race_date,total_days_in_plan(training_cycle.plan.id))

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

        # output workouts for this plan to calendar
        @workouts.each do |workout| 

            # create an new calendar event (this creates json object)
            new_event = service.events.insert.request_schema.new
            new_event.description = workout.workout_type.description
            # (converting description to string replaces nil values with empty string)
            new_event.summary = format_workout(workout.workout_type.name,workout.mileage,workout.description.to_s)
            new_event.start = {"date" => plan_day}
            new_event.end = {"date" => plan_day}
            new_event.reminders = {"useDefault" => false,
                                    "overrides" => [
                                      {'method' => 'email', 'minutes' => 24 * 60},
                                      {'method' => 'sms', 'minutes' => 0},
                                    ]}

            # (Google Calendar API does not currently appear to enable setting free/busy option when inserting events. All events will be marked as busy, which is okay in the sense that we're saving these events to completely separate calendar as the users' primary calendar. See here: https://productforums.google.com/forum/#!topic/calendar/FGvvgTrhgEs)

            # add event to batch
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

        # finally, run the batch to insert all calendar events
        client.execute(batch)

        # console log any errors (put appropriate redirects in here, saving errors to Flash)        
       
        # render :html => "You've just added a bunch of events to your calendar (or not - check the console)"
        flash[:notice] = "You've just created your Training Cycles calendar and exported it to Google!"
        redirect_to dashboards_path
    end
end