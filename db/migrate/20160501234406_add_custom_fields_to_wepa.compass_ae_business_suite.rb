# This migration comes from compass_ae_business_suite (originally 20150814172629)
class AddCustomFieldsToWepa < ActiveRecord::Migration
  def change
    add_column :work_effort_party_assignments, :custom_fields, :text unless column_exists?(:work_effort_party_assignments, :custom_fields)
  end
end
