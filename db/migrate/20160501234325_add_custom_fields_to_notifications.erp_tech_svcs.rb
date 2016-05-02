# This migration comes from erp_tech_svcs (originally 20150819135108)
class AddCustomFieldsToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :custom_fields, :text unless column_exists?(:notifications, :custom_fields)
  end
end
