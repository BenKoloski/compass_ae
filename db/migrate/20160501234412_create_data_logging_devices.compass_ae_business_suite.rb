# This migration comes from compass_ae_business_suite (originally 20151208183111)
class CreateDataLoggingDevices < ActiveRecord::Migration
  def up
    unless table_exists?(:data_logging_devices)
      create_table :data_logging_devices do |t|
        t.references :device_record, polymorphic: true

        t.timestamps
      end

      add_index :data_logging_devices, [:device_record_id, :device_record_type], name: 'data_logging_devices_device_record_idx'
    end

    unless table_exists? :phones
      create_table :phones do |t|
        t.string :description
        t.string :device_id

        t.timestamps
      end
    end

    unless table_exists?(:data_logging_device_entities)
      create_table :data_logging_device_entities do |t|
        t.references :data_logging_device
        t.references :entity, polymorphic: true

        t.timestamps
      end

      add_index :data_logging_device_entities, :data_logging_device_id, name: 'data_logging_device_entities_data_logging_device_idx'
      add_index :data_logging_device_entities, [:entity_id, :entity_type], name: 'data_logging_device_entities_entity_idx'
    end

    unless table_exists?(:device_events)
      create_table :device_events do |t|
        t.references :data_logging_device
        t.references :reading_record, polymorphic: true

        t.timestamps
      end

      add_index :device_events, [:reading_record_id, :reading_record_type], name: 'device_events_reading_record_idx'
    end

    unless table_exists?(:geoloc_events)
      create_table :geoloc_events do |t|
        t.datetime :window_start_at
        t.datetime :window_end_at
        t.decimal :lat
        t.decimal :lng
        t.decimal :altitude
        t.decimal :accuracy
        t.decimal :altitude_accuracy
        t.decimal :heading
        t.decimal :speed
        t.boolean :bad_reading
        t.integer :counter
        t.boolean :gps_validity
        t.decimal :gps_hdop
        t.integer :gps_satellites

        t.timestamps
      end
    end
  end

  def down
    %w{data_logging_devices phones data_logging_device_entities device_events geoloc_events}.each do |table|
      if table_exists? table
        drop_table table
      end
    end
  end

end
