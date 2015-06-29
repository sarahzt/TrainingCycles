class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.references :plan_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
