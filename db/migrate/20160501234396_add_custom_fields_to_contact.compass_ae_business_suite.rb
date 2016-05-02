# This migration comes from compass_ae_business_suite (originally 20150610005329)
class AddCustomFieldsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :custom_fields, :text unless column_exists?(:contacts, :custom_fields)
  end
end
