# This migration comes from compass_ae_business_suite (originally 20150627011910)
class AddCustomFieldsToChargeLines < ActiveRecord::Migration
  def change
    add_column :charge_lines, :custom_fields, :text unless column_exists?(:charge_lines, :custom_fields)
  end
end
