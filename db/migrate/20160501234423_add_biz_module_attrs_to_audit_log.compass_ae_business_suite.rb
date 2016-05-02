# This migration comes from compass_ae_business_suite (originally 20160321001918)
class AddBizModuleAttrsToAuditLog < ActiveRecord::Migration
  def up

    unless column_exists? :audit_logs, :business_module_id
      add_column :audit_logs, :business_module_id, :integer
      add_index :audit_logs, :business_module_id, name: 'audit_logs_biz_module_id_idx'
    end

    unless column_exists? :audit_log_items, :field_definition_id
      add_column :audit_log_items, :field_definition_id, :integer
      add_index :audit_log_items, :field_definition_id, name: 'audit_log_items_field_def_id_idx'
    end

  end

  def down

    if column_exists? :audit_logs, :business_module_id
      remove_column :audit_logs, :business_module_id
    end

    if column_exists? :audit_log_items, :field_definition_id
      remove_column :audit_log_items, :field_definition_id
    end

  end
end
