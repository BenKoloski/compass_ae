class AddTypeToCalendarEvents < ActiveRecord::Migration
  def change
    add_column :calendar_events, :type, :string
  end
end
