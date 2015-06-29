class Plan < ActiveRecord::Base
  belongs_to :plan_type
  has_many :workouts, through: :plan_has_workouts
  has_many :plan_has_workouts
  has_many :training_cycles
end
