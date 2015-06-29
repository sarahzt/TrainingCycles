class CreatePlanTypes < ActiveRecord::Migration
  def change
    create_table :plan_types do |t|
      t.integer :order
      t.string :name

      t.timestamps null: false
    end
  end
end
