class AddColumnDetailsToUserWorkout < ActiveRecord::Migration
  def change
  	add_column :user_workouts, :details, :text
  end
end
