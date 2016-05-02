# This migration comes from compass_ae_business_suite (originally 20150416201502)
class AddStatusToActivityStreamEntry < ActiveRecord::Migration

  def self.up
    add_column :activity_stream_entries, :status, :string, :default => 'unread' unless column_exists?(:activity_stream_entries, :status )
  end

  def self.down
    remove_column :activity_stream_entries, :status
  end

end
