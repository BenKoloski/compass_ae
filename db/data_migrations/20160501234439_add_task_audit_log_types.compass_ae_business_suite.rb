# This migration comes from compass_ae_business_suite (originally 20150719082504)
class AddTaskAuditLogTypes < ActiveRecord::Migration
  def self.up

    task_alt = AuditLogType.create(:description => 'Task', :internal_identifier => 'task')
    [
        {:description => 'Task Created', :internal_identifier => 'task_created'},
        {:description => 'Task Viewed First Time', :internal_identifier => 'task_viewed_first_time'},
        {:description => 'Task Updated', :internal_identifier => 'task_updated'},
        {:description => 'Task Status Changed', :internal_identifier => 'task_status_changed'}
    ].each do |alt_hash|
      AuditLogType.create(alt_hash).move_to_child_of(task_alt)
    end
  end

  def self.down
    mcm_audit_log_type_parent = AuditLogType.find_by_internal_identifier('task')
    mcm_audit_log_type_parent.destroy
  end
end
