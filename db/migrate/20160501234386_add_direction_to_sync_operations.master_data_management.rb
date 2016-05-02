# This migration comes from master_data_management (originally 20150217060516)
class AddDirectionToSyncOperations < ActiveRecord::Migration
  def change
    add_column :sync_operations, :direction, :string unless column_exists? :sync_operations, :direction
  end
end
