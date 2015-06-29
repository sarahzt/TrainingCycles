class CreatePlanHasWorkouts < ActiveRecord::Migration
  def change
    create_table :plan_has_workouts do |t|
      t.references :plan_workout, index: true, foreign_key: true
      t.references :plan, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
