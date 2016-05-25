class CreateCalendarEventTypes < ActiveRecord::Migration
  def change

    ##********************************************************************************************
    ## Typing for Calendar Events (schedulable items)
    ##********************************************************************************************
    unless table_exists?(:calendar_event_types)
      create_table :calendar_event_types do |t|
        t.integer :parent_id
        t.integer :lft
        t.integer :rgt

        #custom columns go here
        t.string :description
        t.string :comments
        t.string :internal_identifier
        t.string :external_identifier

        t.timestamps
      end
    end

  end
end
