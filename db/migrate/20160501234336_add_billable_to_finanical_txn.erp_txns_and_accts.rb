# This migration comes from erp_txns_and_accts (originally 20151231185337)
class AddBillableToFinanicalTxn < ActiveRecord::Migration
  def up
    unless column_exists? :financial_txns, :billable
      add_column :financial_txns, :billable, :boolean, default: false
    end
  end

  def down
    if column_exists? :financial_txns, :billable
      remove_column :financial_txns, :billable
    end
  end
end
