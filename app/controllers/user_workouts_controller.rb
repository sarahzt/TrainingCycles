class UserWorkoutsController < ApplicationController
    before_action :authenticate
	before_action :set_ratings, only: [:new, :create]
	before_action :set_feelings, only: [:new, :create]
	before_action :set_workout_types, only: [:new, :create]

    def authenticate
        deny_access unless signed_in?
    end

    # before_action :plan_started?

    # def plan_started?
    #   if !training_cycle_started? 
    #     flash[:error] = "Training Cycle hasn't started. No workouts to view."
    #     redirect_to dashboards_path
    #   end
    # end

    def set_ratings
    	# hash of ratings for new user workout select menu
     	@ratings = {"" => "0", "1 - Just wasn't mentally into it" => "1", "2 - Struggled, but pulled it off" => "2", "3 - Gave it a good effort" => "3", "4 - I nailed this workout!" => "4"}
    end

    def set_feelings
        # hash of feelings for new user workout select menu
        @feelings = {"" => "0", "Slow or tired" => "1", "My legs felt heavy" => "2", "Good energy" => "3","Legs felt snappy" => "4", "Like I can conquer the world!" => "5"}     
    end

    def set_workout_types 
        # hash of workouts for new user workout select menu, mapped from active record query object
        @workout_types = WorkoutType.all.order(:order).map{|workout| [workout.name,workout.id]}.insert(0, "")
    end

    def get_todays_plan_workout(date)
    	# run helper method to return workout for specified date
    	todays_plan_workout(date)
    end

    def new            	
        # create a new UserWorkout record object for saving form values to later
        @my_workout = UserWorkout.new        

        get_todays_plan_workout(Date.parse(params[:date]))

  #       # start_date of plan
  #       start_date = current_user.training_cycles.last.start_date
  #       # today's date passed as param in page
  #       today_date = Date.parse(params[:date])

  #       # determine which numbered day in plan this is:
  #       # (add one day to account for 1st day of plan: if today_date and start_date are the same, plan_day will be 0; by adding 1.days, we force it to be 1 instead.)
  #       # @plan_day = (today_date - 1.days) - start_date
  #       @plan_day = ((today_date + 1.days) - start_date).to_i
  #       @workout_date = today_date

  #       # lookup workout_type (name/description) by plan_day (for example, plan_day:103)
  #       plan_workout = current_user.training_cycles.last.plan.workouts.find_by(plan_day:@plan_day)

  #       # if a plan workout exists for this plan_day, format it and save for output
  #       if !plan_workout.nil? 
		# 	@scheduled_workout = format_workout(plan_workout.workout_type.name,plan_workout.mileage,plan_workout.description)
		# 	@workout_type_id = plan_workout.workout_type.id
		# 	@workout_name = plan_workout.workout_type.name
		# 	@workout_description = plan_workout.description
		# 	@workout_total_mileage = plan_workout.total_mileage
		# else 
		# 	@scheduled_workout = ""
		# end 

        # hash of ratings for select menu
        # @ratings = {"" => "0", "1 - Just wasn't mentally into it" => "1", "2 - Struggled, but pulled it off" => "2", "3 - Gave it a good effort" => "3", "4 - I nailed this workout!" => "4"}
        # # hash of feelings for select menu
        # @feelings = {"" => "0", "Slow or tired" => "1", "My legs felt heavy" => "2", "Good energy" => "3","Legs felt snappy" => "4", "Like I can conquer the world!" => "5"}      
        # # hash of workouts for select menu, mapped from active record query object
        # @workout_types = WorkoutType.all.order(:order).map{|workout| [workout.name,workout.id]}.insert(0, "")
    end

    ## ADD TRAINING CYCLES ID TO RECORD!!! ADD NESTED PARAMS -> TRAINING CYCLE AND DATE
	def create
		# create a new user_workout record, pre-populated with workout_type object reference
		@my_workout = current_user.user_workouts.new(user_workout_params)

	    if @my_workout.save
			flash[:notice] = "Another one in the books! Your workout has been saved."
			# redirect to where? (return halt processing - no dbl render errors)
			redirect_to :dashboards
	    else
			# loop through errors and save to error_string
			@error_string = ''
			@my_workout.errors.full_messages.each do |message|
			  @error_string += message + '. '
	      	end

	      	# save errors to flash
			flash[:error] =  @error_string  
			# look up workout for specified date in order to display above form
			get_todays_plan_workout(user_workout_params[:workout_date])
			# go back to form page with submitted values populated
			render :new
	    end   
	end

	def user_workout_params
    	params.require(:user_workout).permit(:workout_date,:workout_type_id,:description,:total_mileage,:rating,:feeling,:weather,:details)
    end
end