class RemoveColumnUsersTable < ActiveRecord::Migration
  def change
  	remove_column :users, :calendar_id
  end
end
