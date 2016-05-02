# This migration comes from compass_ae_business_suite (originally 20151218200358)
class AddGeoLocBreadcrumbs < ActiveRecord::Migration
  def up
    unless table_exists? :geo_loc_breadcrumbs
      create_table :geo_loc_breadcrumbs do |t|
        t.references :geoloc_event
        t.references :breadcrumb_entity, polymorphic: true

        t.timestamps
      end

      add_index :geo_loc_breadcrumbs, :geoloc_event_id, name: 'geo_loc_breadcrumb_geoloc_event_idx'
      add_index :geo_loc_breadcrumbs, [:breadcrumb_entity_id, :breadcrumb_entity_type], name: 'geo_loc_breadcrumb_entity_idx'
    end

  end

  def down
    if table_exists?
      drop_table :geo_loc_breadcrumbs
    end

  end
end
