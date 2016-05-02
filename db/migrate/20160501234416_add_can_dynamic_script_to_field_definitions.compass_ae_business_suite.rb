# This migration comes from compass_ae_business_suite (originally 20160107110231)
class AddCanDynamicScriptToFieldDefinitions < ActiveRecord::Migration
  def change
    add_column :field_definitions, :can_dynamic_script, :boolean, default: :false unless column_exists?(:field_definitions, :can_dynamic_script)
  end
end
