# This migration comes from compass_ae_business_suite (originally 20160321011034)
class UpdateAuditLogItemChangeColumnsToText < ActiveRecord::Migration
  def up
    unless column_exists? :audit_log_items, :audit_log_item_old_value, :text
      change_column :audit_log_items, :audit_log_item_old_value, :text
    end

    unless column_exists? :audit_log_items, :audit_log_item_value, :text
      change_column :audit_log_items, :audit_log_item_value, :text
    end
  end

  def down
    if column_exists? :audit_log_items, :audit_log_item_old_value, :text
      change_column :audit_log_items, :audit_log_item_old_value, :string
    end

    if column_exists? :audit_log_items, :audit_log_item_value, :text
      change_column :audit_log_items, :audit_log_item_value, :strings
    end
  end
end
