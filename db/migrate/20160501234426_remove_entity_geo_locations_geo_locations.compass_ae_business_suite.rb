# This migration comes from compass_ae_business_suite (originally 20160329133327)
class RemoveEntityGeoLocationsGeoLocations < ActiveRecord::Migration
  def up
    if table_exists? :entity_geo_locations_geo_locations
      execute('update entity_geo_locations set geo_location_id = (select max(geo_location_id)
           from entity_geo_locations_geo_locations
           where entity_geo_location_id = entity_geo_locations.id
           group by entity_geo_location_id)')

      drop_table :entity_geo_locations_geo_locations
    end
  end

  def down
    unless table_exists? :entity_geo_locations_geo_locations
      create_table :entity_geo_locations_geo_locations, id: false do |t|

        t.references :entity_geo_location
        t.references :geo_location

      end

      add_index :entity_geo_locations_geo_locations, [:entity_geo_location_id, :geo_location_id], name: 'entity_geo_locations_geo_locations_idx'
    end

    execute('insert into entity_geo_locations_geo_locations
             (geo_location_id, entity_geo_location_id)
             (select geo_location_id, id from entity_geo_locations)')
  end
end
