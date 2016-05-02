# This migration comes from compass_ae_business_suite (originally 20151016140949)
class CreateRepeats < ActiveRecord::Migration
  def up

    unless table_exists? :repeats
      create_table :repeats do |t|
        t.references :repeatable_record, polymorphic: true
        t.string :repeatable_type
        t.integer :repeat_interval
        t.string :repeat_week_days
        t.date :start_on
        t.date :end_on
        t.datetime :original_start_at
        t.datetime :original_end_at
        t.integer :repeat_count
        t.integer :max_repeats
        t.boolean :active, default: true
        t.string :series_id

        t.timestamps
      end

      add_index :repeats, :active
      add_index :repeats, :series_id
      add_index :repeats, :original_start_at
      add_index :repeats, :original_end_at
      add_index :repeats, [:repeatable_record_id, :repeatable_record_type], name: 'repeatable_record_idx'
    end

  end

  def down

    if table_exists? :repeats
      drop_table :repeats
    end

  end

end
