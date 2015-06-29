class UserWorkout < ActiveRecord::Base
	belongs_to :user
	belongs_to :workout_type

	# (using 'validate' adds a custom method to validates class built-in methods)
	validate :workout_date_is_date?
	validates :workout_type, presence: true
	validates :total_mileage, presence: true, numericality: true

	# validate that we received an actual date
	def workout_date_is_date?
		if !self.workout_date.is_a?(Date)
			errors.add(:workout_date, 'must be a valid date') 
		end
	end
end
