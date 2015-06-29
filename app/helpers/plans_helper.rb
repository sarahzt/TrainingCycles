module PlansHelper	
	def plan_type(plan_type_id)
		@plan_type = PlanType.find(plan_type_id).name
	end

	def current_user_plan
		# THIS ISN'T USED YET...
		# returns plan for currently logged in user
        @plan = current_user.training_cycles.last.plan
	end

	def total_days_in_plan(plan_id)
		# return number of actual workouts (not filler days)
		@total_days_in_plan ||= Plan.find(plan_id).workouts.where("plan_day > 0").count
	end

	def first_date_of_plan(race_date,total_days_in_plan)
		# (advance 1 day because the actual date of race isn't included in plan workouts - plan ends the day before)
		@first_date_of_plan ||= (race_date - total_days_in_plan) + 1.day
	end

	def week_count(total_days)
		# number of weeks in plan (16 - 20 is average) 
		# (have to use 7.0 instead of 7 because we want a float, such as 17.85, that we can round up to 18, for example)
		@week_count = (total_days/7.00).to_f.ceil
	end

	def plan_day(date)
		# determine which numbered day of user's current plan this is:
        # (add one day to account for 1st day of plan: if todays_date and start_date are the same, plan_day will be 0; by adding 1.days, we force it to be 1 instead.)
		@plan_day = ((date + 1.days) - training_cycle_start_date).to_i
	end

	# return details for one workout for specified date
	def todays_plan_workout(date)        
        # find workout by plan_day (for example, plan_day:103), eager-loading workout_type for output
        plan_workout = current_user.training_cycles.last.plan.workouts.includes(:workout_type).find_by(plan_day:plan_day(date))

        # if a plan workout exists for this plan_day, format it and save for output
        if !plan_workout.nil? 
			@workout_scheduled = format_workout(plan_workout.workout_type.name,plan_workout.mileage,plan_workout.description)
			@workout_type_id = plan_workout.workout_type.id
			@workout_name = plan_workout.workout_type.name
			@workout_description = plan_workout.description
			@workout_type_description = plan_workout.workout_type.description
			@workout_total_mileage = plan_workout.total_mileage
	        @workout_date = date
		else 
			@workout_scheduled = ""
		end 
	end

	# return details for a weeks worth of workouts around specified date
	def weekly_plan_workouts(todays_date)        
        # lookup week day value of today's workout (name/description) by plan_day.
        # (for example, plan_day:103 is held on week_day:0 (Sunday))
        plan_week_day = current_user.training_cycles.last.plan.workouts.find_by(plan_day:plan_day(todays_date)).week_day

        # returns plan_day numbers for beginning and end of week surrounding the plan_day to create a weekly range from which to pull workouts
        # (if plan_day = 10, then week_start (1) & week_end (7) are plan_day:6 & 12 respectively)
        plan_week_start = (plan_day(todays_date) + 1) - plan_week_day
		plan_week_end = plan_day(todays_date) + (7 - plan_week_day)

		@workouts = current_user.training_cycles.last.plan.workouts.includes(:workout_type).where(plan_day:plan_week_start..plan_week_end).order("plan_day")
	end

	# def all_plan_workouts
	# 	# return details for a weeks worth of workouts around specified date 
	# 	@workouts = current_user.training_cycles.last.plan.workouts.includes(:workout_type).where("plan_day > 0").order("plan_day")
	# end

	# determine if user picked a race date that's sooner than training period end
	def race_too_soon?(race_date)
		# (should be able to pass in training week length for plans that are shorter than 18 weeks)
	    Date.today > (race_date - 18.weeks)
    end
end
