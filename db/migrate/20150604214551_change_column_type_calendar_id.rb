class ChangeColumnTypeCalendarId < ActiveRecord::Migration
  def change
  	change_column :training_cycles, :calendar_id, :string
  end
end
