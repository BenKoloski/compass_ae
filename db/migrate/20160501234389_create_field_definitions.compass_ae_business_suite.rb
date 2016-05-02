# This migration comes from compass_ae_business_suite (originally 20140320084252)
class CreateFieldDefinitions < ActiveRecord::Migration
  def up

    unless table_exists?(:dynamic_ui_components)
      create_table :dynamic_ui_components do |t|
        t.string :description
        t.string :title
        t.string :label
        t.integer :position
        # icon to show in organizer
        t.string :icon_src
        # a place to hold meta data about this UI component
        t.text :meta_data
        # type column for STI
        t.string :type
        # class name for UI rendering. If nil the default rendering mechanism is used
        t.string :renderer_name

        t.boolean :can_edit_detail_view, :default => true
        t.boolean :can_edit_list_view, :default => true

        t.references :business_module

        t.text :compiled_view
        t.datetime :compiled_at

        t.timestamps
      end

      add_index :dynamic_ui_components, :position
      add_index :dynamic_ui_components, :business_module_id
      add_index :dynamic_ui_components, :can_edit_detail_view
      add_index :dynamic_ui_components, :can_edit_list_view
    end

    unless table_exists?(:field_definitions)
      create_table :field_definitions do |t|
        t.string :field_name
        t.string :label
        t.text :field_attributes
        t.boolean :is_custom
        t.references :field_type
        t.boolean :added_to_view
        t.boolean :locked, :boolean, :default => 'false'

        # a place to select options for this field
        t.text :select_options

        # a place to hold meta data about this UI component
        t.text :meta_data

        t.integer :position

        t.timestamps
      end

      add_index :field_definitions, :added_to_view
      add_index :field_definitions, :field_type_id
      add_index :field_definitions, :field_name
      add_index :field_definitions, :position
    end

    unless table_exists?(:field_sets)
      create_table :field_sets do |t|
        t.string :field_set_name
        t.string :title
        t.string :label
        t.string :content_area
        t.integer :position, :default => 1
        t.integer :columns, :default => 1
        t.boolean :locked, :boolean, :default => 'false'

        # a place to hold meta data about this UI component
        t.text :meta_data

        t.references :dynamic_ui_component

        t.timestamps
      end

      add_index :field_sets, :dynamic_ui_component_id
      add_index :field_sets, :field_set_name
      add_index :field_sets, :position
    end

    unless table_exists?(:component_member_fields)
      create_table :component_member_fields do |t|
        t.string :description
        t.integer :column, :default => 1
        t.integer :position, :default => 1
        t.string :view

        t.references :field_definition
        t.references :component_record, :polymorphic => true

        t.timestamps
      end

      add_index :component_member_fields, :field_definition_id
      add_index :component_member_fields, :column
      add_index :component_member_fields, :position
      add_index :component_member_fields, [:component_record_id, :component_record_type], :name => 'component_mem_component_rec_idx'
      add_index :component_member_fields, :view
    end

    unless table_exists?(:field_types)
      create_table :field_types do |t|
        t.string :description
        t.string :internal_identifier

        # a place to hold meta data about this UI component
        t.text :meta_data

        # awesome nested set columns
        t.integer :parent_id
        t.integer :lft
        t.integer :rgt

        t.timestamps
      end

      add_index :field_types, :internal_identifier
    end
  end

  def down
    [:dynamic_ui_components, :field_definitions, :field_types,
     :field_sets, :component_member_fields].each do |table|
      drop_table table
    end
  end
end
