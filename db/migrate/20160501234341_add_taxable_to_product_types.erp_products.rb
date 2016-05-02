# This migration comes from erp_products (originally 20150622150625)
class AddTaxableToProductTypes < ActiveRecord::Migration
  def change
    add_column :product_types, :taxable, :boolean unless column_exists? :product_types, :taxable
  end
end
