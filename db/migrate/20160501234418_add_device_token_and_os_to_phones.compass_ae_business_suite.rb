# This migration comes from compass_ae_business_suite (originally 20160119104919)
class AddDeviceTokenAndOsToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :device_token, :string unless column_exists?(:phones, :device_token)
    add_column :phones, :os, :string unless column_exists?(:phones, :os)
    add_index :phones, [:device_id, :os], name: 'phones_device_idx'
  end
end
