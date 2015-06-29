class CreateWorkoutTypes < ActiveRecord::Migration
  def change
    create_table :workout_types do |t|
      t.integer :order
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
