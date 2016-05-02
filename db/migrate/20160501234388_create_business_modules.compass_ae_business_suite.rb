# This migration comes from compass_ae_business_suite (originally 20140311201057)
class CreateBusinessModules < ActiveRecord::Migration
  def up

    unless table_exists?(:business_modules)
      create_table :business_modules do |t|
        t.string :description
        t.string :internal_identifier

        # whether this business module is a template
        t.boolean :is_template, default: false

        # whether this business module can be associated to other business modules
        t.boolean :can_associate, default: false

        # name of data manager to initialize
        t.string :data_manager_name

        # xtype of components to render with creating or associating a module
        t.string :xtype_for_create
        t.string :xtype_for_associate

        # for sub-classes
        t.string :type

        t.boolean :can_create
        t.string :parent_module_type
        t.string :root_model

        t.integer :position

        t.text :scoped_by
        t.text :meta_data

        # association to application
        t.references :application

        # awesome nested set columns
        t.integer :parent_id
        t.integer :lft
        t.integer :rgt

        t.timestamps
      end

      add_index :business_modules, :application_id
      add_index :business_modules, :position
      add_index :business_modules, :internal_identifier
      add_index :business_modules, :scoped_by
      add_index :business_modules, :is_template
      add_index :business_modules, [:parent_id, :lft, :rgt], name: "business_modules_aw_nested_set_idx"
    end

    unless table_exists?(:business_module_associations)
        create_table :business_module_associations do |t|
          t.references :business_module_from
          t.references :business_module_to
          t.references :association_type
          t.text :association_attributes
          t.text :scoped_by

          t.timestamps
        end

      add_index :business_module_associations, :business_module_from_id
      add_index :business_module_associations, :business_module_to_id
      add_index :business_module_associations, :association_type_id
      add_index :business_module_associations, :scoped_by
    end

    unless table_exists?(:business_module_association_types)
        create_table :business_module_association_types do |t|
          t.string :description
          t.string :internal_identifier

          # awesome nested set columns
          t.integer :parent_id
          t.integer :lft
          t.integer :rgt

          t.timestamps
        end

        add_index :business_module_association_types, :internal_identifier
        add_index :business_module_association_types, [:parent_id, :lft, :rgt], name: "business_module_assoc_aw_nested_set_idx"
    end

  end

  def down
    [
        :business_modules,
        :business_module_associations,
        :business_module_association_types
    ].each do |table|
      drop_table table
    end
  end
end