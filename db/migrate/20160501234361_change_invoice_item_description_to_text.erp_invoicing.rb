# This migration comes from erp_invoicing (originally 20150424193506)
class ChangeInvoiceItemDescriptionToText < ActiveRecord::Migration
  def up
    change_column :invoice_items, :item_description, :text
  end

  def down
    change_column :invoice_items, :item_description, :string
  end
end
