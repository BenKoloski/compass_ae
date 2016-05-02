# This migration comes from compass_ae_business_suite (originally 20150809185602)
class AddGeoLocationConfigToPostalAddress < ActiveRecord::Migration
  def up
    add_column :postal_addresses, :geo_location_config, :text unless column_exists? :postal_addresses, :geo_location_config
  end

  def down
    remove_column :postal_addresses, :geo_location_config if column_exists? :postal_addresses, :geo_location_config
  end
end
