class AddColumnCalendarIdToTrainingCycle < ActiveRecord::Migration
  def change
  	add_column :training_cycles, :calendar_id, :integer
  end
end
