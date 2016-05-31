class AddIndexToCalendarEvents < ActiveRecord::Migration
  def change
    add_index :calendar_events, :starttime
    add_index :calendar_events, :endtime
  end
end
