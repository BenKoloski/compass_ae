# This migration comes from compass_ae_business_suite (originally 20150806193817)
class AddGeolocatable < ActiveRecord::Migration
  def up
    unless table_exists? :geo_locations
      create_table :geo_locations do |t|

        t.datetime "window_start_at"
        t.datetime "window_end_at"
        t.decimal "lat", :precision => 12, :scale => 8
        t.decimal "lng", :precision => 12, :scale => 8
        t.float "altitude"
        t.float "accuracy"
        t.float "altitude_accuracy"
        t.float "heading"
        t.float "speed"
        t.boolean "bad_reading", :default => false
        t.integer "counter", :default => 1

        t.timestamps
      end

      add_index :geo_locations, ["window_end_at"], name: "geo_locations_window_end_at_index"
      add_index :geo_locations, ["window_start_at"], name: "geo_locations_window_start_at_index"
    end

    unless table_exists? :entity_geo_locations
      create_table :entity_geo_locations do |t|

        t.references :entity, polymorphic: true
        t.references :geo_location

        t.timestamps

      end

      add_index :entity_geo_locations, [:entity_id, :entity_type], name: 'entity_geo_locations_entity_idx'
    end

    unless table_exists? :entity_geo_locations_geo_locations
      create_table :entity_geo_locations_geo_locations, id: false do |t|

        t.references :entity_geo_location
        t.references :geo_location

      end

      add_index :entity_geo_locations_geo_locations, [:entity_geo_location_id, :geo_location_id], name: 'entity_geo_locations_geo_locations_idx'
    end

    # add geo_location_config to Party
    add_column :parties, :geo_location_config, :text

  end

  def down
    [:geo_locations, :entity_geo_locations, :entity_geo_locations_geo_locations].each do |table|
      drop_table table if table_exists? table
    end

    remove_column :parties, :geo_location_config
  end
end
