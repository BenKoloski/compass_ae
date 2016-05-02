# This migration comes from compass_ae_business_suite (originally 20150911214803)
class AddCustomFieldsToTimeEntry < ActiveRecord::Migration
  def change
    add_column :time_entries, :custom_fields, :text unless column_exists?(:time_entries, :custom_fields)
  end
end
