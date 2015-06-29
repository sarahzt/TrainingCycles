class TrainingCyclesController < ApplicationController
    before_action :authenticate

    def authenticate
      deny_access unless signed_in?
    end

  	def index
      @cycles = User.find(session[:user_id]).training_cycles.joins(:plan)
  	end
	
    def create
      # create a new active record object
      @new_cycle = current_user.training_cycles.new(plan:Plan.find(params[:plan_id]))
      # date of target race
      @new_cycle.race_date = Date.parse(params[:race_date])
      # determine date of first actual workout in plan
      @new_cycle.start_date = first_date_of_plan(Date.parse(params[:race_date]),total_days_in_plan(params[:plan_id]))
      # @plan_day = (@today_date - 1.days) - @start_date

      # check to see if save called back with success or error
      if @new_cycle.save
        # (not sure if we'll end up needing this in session...)
        session[:training_cycle_id] = @new_cycle.id 
        # redirect to method that adds workouts for this plan as events in Google Calendar
        redirect_to create_calendar_path
      else
        # loop through errors and save to error_string
        @error_string = ''
        @new_cycle.errors.full_messages.each do |message|
            @error_string += message + '. '
        end
        # save errors to flash
        flash[:error] =  @error_string  
        render :html => "bad"
      end    
    end

    def new
      # this returns multple plans
      # display matching training plans - need form validation on previous form? group by here?
      # @matching_plans = Plan.where(plan:plan_params[:plan],plan_level_type_id:plan_params[:plan_level_type_id].to_i,plan_type_id:plan_params[:plan_type_id].to_i)

      # @matching_plans = Plan.where(training_params

      @new_cycle = TrainingCycle.new

      render 'new'
    end

    def training_params
      # (actual plan_id that user chose will be updated later)
      params.require(:training).permit(:plan_id,:startdate,:enddate,:racedate)
    end
end