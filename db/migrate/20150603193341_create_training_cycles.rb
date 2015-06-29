class CreateTrainingCycles < ActiveRecord::Migration
  def change
    create_table :training_cycles do |t|
      t.references :user, index: true, foreign_key: true
      t.references :plan, index: true, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.date :race_date
      t.references :experience_type, index: true, foreign_key: true
      t.references :mileage_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
