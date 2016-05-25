class AddTypeToCalEvt < ActiveRecord::Migration
  def change
    add_column :calendar_events, :calendar_event_type_id, :integer
    add_index :calendar_events, :calendar_event_type_id
  end
end
