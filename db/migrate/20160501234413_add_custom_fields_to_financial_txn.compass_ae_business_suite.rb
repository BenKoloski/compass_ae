# This migration comes from compass_ae_business_suite (originally 20151211152251)
class AddCustomFieldsToFinancialTxn < ActiveRecord::Migration
  def change
    add_column :financial_txns, :custom_fields, :text unless column_exists?(:financial_txns, :custom_fields)
  end
end
