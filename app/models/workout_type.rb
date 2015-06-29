class WorkoutType < ActiveRecord::Base
	has_many :workouts
	has_many :user_workouts
end
