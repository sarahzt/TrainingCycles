class SetTotalMileage < ActiveRecord::Migration
  # copy column values from one column to another
  def change
  	Workout.connection.execute("update workouts set total_mileage=mileage")
  end

  def self.down
  end
end
