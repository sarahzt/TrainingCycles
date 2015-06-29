class WorkoutsController < ApplicationController
	before_action :authenticate

  	def authenticate
      deny_access unless signed_in?
    end
	
	# plan_workouts GET /plans/:plan_id/workouts(.:format)
	def index
		# look up plan record
		@plan = Plan.find(params[:plan_id])

		# look up all workouts associated with this plan, eager-loading workout_type for output
		# (include filler days leading up to first workout, by NOT checking 'where("plan_day > 0")'')
		@workouts = @plan.workouts.includes(:workout_type).order("plan_day")

		# determine number of weeks in plan, based on total number of plan days
		@week_count = week_count(@workouts.count)

		# keeps sum of each week's mileage - initialize to 0
		@weekly_mileage = 0

		# display monday through sunday (rails default is sunday first)
		@weekday_order = [1,2,3,4,5,6,0]
	end

	# plan_workout GET /plans/:plan_id/workouts/:id(.:format)
	def show
		# look up plan record
		@plan = Plan.find(params[:plan_id])
		
		# look up associated workout record, eager-loading workout_type for output
		@workout = @plan.workouts.includes(:workout_type).find(params[:id])
	end
end