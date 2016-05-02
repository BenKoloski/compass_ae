# This migration comes from compass_ae_business_suite (originally 20140320084253)
class AddCustomFieldsColumns < ActiveRecord::Migration
  def up
    %w{parties product_feature_types product_features product_feature_values
       product_feature_interactions biz_txn_events invoices order_txns order_line_items
       party_relationships file_assets product_types simple_product_offers skill_types
       party_skills position_types positions position_fulfillments positions
       descriptive_assets experiences staffing_positions
      }.each do |table|
      add_column table, :custom_fields, :text unless column_exists?(table, :custom_fields)
    end
  end

  def down
  end
end
