# This migration comes from compass_ae_business_suite (originally 20150713231704)
class AddGlobalFlagToActivityStreamEntry < ActiveRecord::Migration
  def up
    add_column :activity_stream_entries, :global, :boolean, :default => false unless column_exists? :activity_stream_entries, :global
    add_index :activity_stream_entries, :global, name: 'activity_stream_entry_global_idx' unless index_exists? :activity_stream_entries, name: 'activity_stream_entry_global_idx'
  end

  def down
    remove_column :activity_stream_entries, :global if column_exists? :activity_stream_entries, :global
  end
end
