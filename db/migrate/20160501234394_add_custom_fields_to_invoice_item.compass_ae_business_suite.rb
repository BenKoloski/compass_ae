# This migration comes from compass_ae_business_suite (originally 20150416194408)
class AddCustomFieldsToInvoiceItem < ActiveRecord::Migration
  def change
    add_column :invoice_items, :custom_fields, :text unless column_exists?(:invoice_items, :custom_fields)
  end
end
