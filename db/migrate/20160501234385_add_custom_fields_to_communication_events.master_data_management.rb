# This migration comes from master_data_management (originally 20140320084253)
class AddCustomFieldsToCommunicationEvents < ActiveRecord::Migration
  def up
    add_column :communication_events, :custom_fields, :text unless column_exists?(:communication_events, :custom_fields)
  end

  def down
    remove_column :communication_events, :custom_fields, :text if column_exists?(:communication_events, :custom_fields)
  end
end
