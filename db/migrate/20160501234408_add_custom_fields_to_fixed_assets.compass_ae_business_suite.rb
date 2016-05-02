# This migration comes from compass_ae_business_suite (originally 20150913201601)
class AddCustomFieldsToFixedAssets < ActiveRecord::Migration
  def change
    add_column :fixed_assets, :custom_fields, :text unless column_exists?(:fixed_assets, :custom_fields)
  end
end
