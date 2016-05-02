# This migration comes from compass_ae_business_suite (originally 20150715235142)
class AddCustomFieldsToBizTxnAcctRoot < ActiveRecord::Migration
  def up
    add_column :biz_txn_acct_roots, :custom_fields, :text unless column_exists? :biz_txn_acct_roots, :custom_fields
  end

  def down
    remove_column :biz_txn_acct_roots, :custom_fields, :text if column_exists? :biz_txn_acct_roots, :custom_fields
  end
end
