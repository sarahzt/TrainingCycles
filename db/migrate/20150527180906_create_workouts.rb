class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.integer :plan_day
      t.integer :week_day
      t.string :description
      t.references :workout_type, index: true, foreign_key: true
      t.integer :mileage

      t.timestamps null: false
    end
  end
end
