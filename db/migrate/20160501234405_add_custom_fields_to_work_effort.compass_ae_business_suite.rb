# This migration comes from compass_ae_business_suite (originally 20150809201500)
class AddCustomFieldsToWorkEffort < ActiveRecord::Migration
  def change
    add_column :work_efforts, :custom_fields, :text unless column_exists?(:work_efforts, :custom_fields)
  end
end
