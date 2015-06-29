class ChangeColumnNamePlanWorkout < ActiveRecord::Migration
  def change
  	rename_column :plan_has_workouts, :plan_workout_id, :workout_id
  end
end