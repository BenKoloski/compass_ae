# This migration comes from compass_ae_business_suite (originally 20160205005335)
class AddCustomFieldsToUnitOfMeasurement < ActiveRecord::Migration
  def up
    add_column :unit_of_measurements, :custom_fields, :text unless column_exists?(:unit_of_measurements, :custom_fields)
  end

  def down
    remove_column :unit_of_measurements, :custom_fields, :text if column_exists?(:unit_of_measurements, :custom_fields)
  end
end
