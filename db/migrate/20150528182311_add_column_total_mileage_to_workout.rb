class AddColumnTotalMileageToWorkout < ActiveRecord::Migration
  def change
  	 add_column :workouts, :total_mileage, :integer
  end

  def self.down
  end
end
