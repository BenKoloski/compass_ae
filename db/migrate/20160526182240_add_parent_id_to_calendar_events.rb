class AddParentIdToCalendarEvents < ActiveRecord::Migration
  def change
    add_column :calendar_events, :parent_id, :integer
  end
end
