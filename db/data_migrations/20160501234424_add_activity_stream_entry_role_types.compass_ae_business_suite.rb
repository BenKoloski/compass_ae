# This migration comes from compass_ae_business_suite (originally 20150417122021)
class AddActivityStreamEntryRoleTypes < ActiveRecord::Migration
  def self.up
    role_type_parent = RoleType.find_or_create('activity_stream_entry', 'Activity Stream Entry')
    RoleType.find_or_create('activity_stream_entry_notified', 'Notified', role_type_parent)
  end

  def self.down
    RoleType.iid('activity_stream_entry_notified').destroy_all
  end
end
