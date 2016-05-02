# This migration comes from compass_ae_business_suite (originally 20151027144644)
class AddManualEntryDateToTimeEntries < ActiveRecord::Migration
  def up
    unless column_exists? :time_entries, :manual_entry_start_date
      add_column :time_entries, :manual_entry_start_date, :date
    end
  end

  def down
    if column_exists? :time_entries, :manual_entry_start_date
      remove_column :time_entries, :manual_entry_start_date
    end
  end
end
