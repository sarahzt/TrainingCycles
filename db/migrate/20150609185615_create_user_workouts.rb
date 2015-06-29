class CreateUserWorkouts < ActiveRecord::Migration
  def change
    create_table :user_workouts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :workout_type, index: true, foreign_key: true
      t.date :workout_date
      t.integer :rating
      t.string :weather
      t.string :feeling
      t.text :description
      t.integer :total_mileage

      t.timestamps null: false
    end
  end
end
