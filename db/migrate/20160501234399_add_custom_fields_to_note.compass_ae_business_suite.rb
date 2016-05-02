# This migration comes from compass_ae_business_suite (originally 20150627012323)
class AddCustomFieldsToNote < ActiveRecord::Migration
  def change
    add_column :notes, :custom_fields, :text unless column_exists?(:notes, :custom_fields)
  end
end
