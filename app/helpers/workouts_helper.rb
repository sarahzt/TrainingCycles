module WorkoutsHelper
	def format_workout(name,mileage,description)
		# output workout
		case name
			when "Off" then name + ""
			when "Tempo Run" then name + ": " + mileage.to_s + " miles"
			when "Speed Workout" then name + ": " + description
			when "Strength Workout" then name + ": " + description
			when "Race Day" then name.upcase
			else
				name + ": " + mileage.to_s + " miles"
		end
	end
end
