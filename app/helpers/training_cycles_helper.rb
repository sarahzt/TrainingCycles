module TrainingCyclesHelper

	def training_cycle_start_date
		# returns start_date of user's current training cycle plan
        @training_cycle_start_date = current_user.training_cycles.last.start_date
	end

	def training_cycle_started?
		# check to see if training cycle has started yet 
		# (if it's not nil and not in the future, returns true)
		!training_cycle_start_date.nil? && !training_cycle_start_date.future?
	end

end
