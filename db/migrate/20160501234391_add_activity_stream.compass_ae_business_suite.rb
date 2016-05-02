# This migration comes from compass_ae_business_suite (originally 20140515182825)
class AddActivityStream < ActiveRecord::Migration
  def up

    unless table_exists?(:activity_stream_entries)
      create_table :activity_stream_entries do |t|
        t.text :content
        t.references :activity_stream_entry_record, :polymorphic => true
        t.references :activity_stream_entry_type

        t.timestamps
      end

      add_index :activity_stream_entries,
                [:activity_stream_entry_record_id, :activity_stream_entry_record_type],
                :name => 'activity_entry_record_idx'
      add_index :activity_stream_entries, :activity_stream_entry_type_id
    end

    unless table_exists?(:activity_stream_entry_types)
      create_table :activity_stream_entry_types do |t|
        t.string :description
        t.string :internal_identifier

        t.timestamps
      end
    end

    unless table_exists?(:activity_stream_entry_pty_roles)
      create_table :activity_stream_entry_pty_roles do |t|
        t.references :activity_stream_entry
        t.references :party
        t.references :role_type

        t.timestamps
      end

      add_index :activity_stream_entry_pty_roles, :activity_stream_entry_id, :name => 'activity_stream_pty_role_stream_id_idx'
      add_index :activity_stream_entry_pty_roles, :party_id, :name => 'activity_stream_pty_role_party_id_id_idx'
      add_index :activity_stream_entry_pty_roles, :role_type_id, :name => 'activity_stream_pty_role_role_id_idx'
    end

  end

  def down
    drop_table :activity_stream_entries
    drop_table :activity_stream_entry_types
    drop_table :activity_stream_entry_pty_roles
  end
end
