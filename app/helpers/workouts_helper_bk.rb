module WorkoutsHelper

	def format_workout(name,mileage,description)
		# output workout
		# SZT 06/01/15: this needs to be updated - name now contains words Run or Workout
		case name
			when "Off" then workoutStr = "<strong>" + name + "</strong>"
			when "Tempo" then workoutStr = "<strong>Tempo Run:</strong><br> " + mileage.to_s + " miles"
			when "Speed" then workoutStr = "<strong>Speed Workout:</strong><br> " + description
			when "Strength" then workoutStr = "<strong>Strength Run:</strong><br> " + description
			else
				workoutStr = "<strong>" + name + " Run:</strong><br>" + mileage.to_s + " miles"
		end
	end
end
