class PlanHasWorkout < ActiveRecord::Base
  belongs_to :workout
  belongs_to :plan
end
