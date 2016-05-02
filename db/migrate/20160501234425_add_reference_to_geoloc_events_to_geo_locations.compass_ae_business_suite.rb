# This migration comes from compass_ae_business_suite (originally 20160327143531)
class AddReferenceToGeolocEventsToGeoLocations < ActiveRecord::Migration
  def up
    unless column_exists? :geo_locations, :geoloc_event_id
      add_column :geo_locations, :geoloc_event_id, :integer
      add_index :geo_locations, :geoloc_event_id, name: 'geo_loc_geoloc_event_idx'
    end
  end

  def down
    if column_exists? :geo_locations, :geoloc_event_id
      remove_column :geo_locations, :geoloc_event_id
    end
  end
end
