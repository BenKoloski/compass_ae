# This migration comes from master_data_management (originally 20100526152942)
class MdmSetup < ActiveRecord::Migration
  def self.up
    unless table_exists?(:mdm_entities)
      create_table :mdm_entities do |t|
        t.references :entity_record, :polymorphic => true

        t.timestamps
      end

      add_index :mdm_entities, [:entity_record_id, :entity_record_type], :name => 'entity_record_idx'
    end

    unless table_exists?(:mdm_external_mappings)
      create_table :mdm_external_mappings do |t|
        t.string :description
        t.references :mdm_entity
        t.references :external_system

        t.timestamps
      end

      add_index :mdm_external_mappings, :mdm_entity_id
      add_index :mdm_external_mappings, :external_system_id
    end

    unless table_exists?(:mdm_external_attributes)
      create_table :mdm_external_attributes do |t|
        t.references :mdm_external_mapping
        t.boolean :is_primary_key
        t.boolean :is_active
        t.string :table_name
        t.string :column_name
        t.string :value

        t.timestamps
      end

      add_index :mdm_external_attributes, :mdm_external_mapping_id, :name => 'mdm_mapping_id_idx'
    end


    unless table_exists?(:external_systems)
      create_table :external_systems do |t|
        t.string :description
        t.string :internal_identifier
        t.string :external_identifier
        t.string :db_config_name
        t.string :encrypted_private_key
        t.string :public_key
        t.string :username
        t.string :encrypted_password
        t.boolean :active
        t.text :custom_data

        t.timestamps
      end
    end

    unless table_exists?(:sync_operations)
      create_table :sync_operations do |t|
        t.references :external_system
        t.references :mdm_entity
        t.string :change_type
        t.string :model_class
        t.text :context

        t.timestamps
      end

      add_index :sync_operations, :mdm_entity_id, :name => 'sync_operations_mdm_entity_idx'
      add_index :sync_operations, :external_system_id, :name => 'sync_operations_external_system_idx'
    end

  end

  def self.down
    [:mdm_entities,
     :mdm_external_mappings,
     :mdm_external_attributes,
     :external_systems, :sync_operations].each do |table|
      if table_exists?(table)
        drop_table table
      end
    end
  end

end
