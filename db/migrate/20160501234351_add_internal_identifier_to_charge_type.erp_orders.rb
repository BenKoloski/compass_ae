# This migration comes from erp_orders (originally 20150624000721)
class AddInternalIdentifierToChargeType < ActiveRecord::Migration
  def change
    add_column :charge_types, :internal_identifier, :string unless column_exists? :charge_types, :internal_identifier
  end
end
