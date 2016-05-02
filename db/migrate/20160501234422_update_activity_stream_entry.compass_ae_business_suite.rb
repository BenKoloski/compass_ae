# This migration comes from compass_ae_business_suite (originally 20160316144036)
class UpdateActivityStreamEntry < ActiveRecord::Migration
  def up

    if index_exists? :activity_stream_entries, :activity_stream_entry_type_id, name: 'index_activity_stream_entries_on_activity_stream_entry_type_id'
      rename_index :activity_stream_entries, 'index_activity_stream_entries_on_activity_stream_entry_type_id', 'act_stream_entries_on_act_stream_entry_type_id_idx'
    end

    if column_exists? :activity_stream_entries, :status
      remove_column :activity_stream_entries, :status
    end

    unless column_exists? :activity_stream_entry_pty_roles, :status
      add_column :activity_stream_entry_pty_roles, :status, :string, default: 'unread'

      add_index :activity_stream_entry_pty_roles, :status, name: 'act_stream_entry_pty_roles_status_idx'
    end

    unless column_exists? :activity_stream_entries, :is_private
      add_column :activity_stream_entries, :is_private, :boolean, default: false
      remove_column :activity_stream_entries, :global

      add_index :activity_stream_entries, :is_private, name: 'act_stream_entry_is_private_idx'
    end

  end

  def down

    if index_exists? :activity_stream_entries, :activity_stream_entry_type_id, name: 'act_stream_entries_on_act_stream_entry_type_id_idx'
      rename_index :activity_stream_entries, 'act_stream_entries_on_act_stream_entry_type_id_idx', 'index_activity_stream_entries_on_activity_stream_entry_type_id'
    end

    if column_exists? :activity_stream_entry_pty_roles, :status
      remove_column :activity_stream_entry_pty_roles, :status
    end

    unless column_exists? :activity_stream_entries, :status
      add_column :activity_stream_entries, :status, :string, default: 'unread'
    end

    if column_exists? :activity_stream_entries, :is_private
      add_column :activity_stream_entries, :global, :boolean, default: true
      remove_column :activity_stream_entries, :is_private

    end

  end
end
