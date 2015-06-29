class AddColumnTrainingCycleIdToUserWorkout < ActiveRecord::Migration
  def change
  	add_reference :user_workouts, :training_cycle, index: true, foreign_key: true
  end
end
