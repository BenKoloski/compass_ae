# This migration comes from compass_ae_business_suite (originally 20150718053900)
class AddCustomFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :custom_fields, :text unless column_exists?(:projects, :custom_fields)
  end
end
