# This migration comes from compass_ae_business_suite (originally 20151220234017)
class AddCustomFieldsToTransportationRoutes < ActiveRecord::Migration
  def change
    add_column :transportation_routes, :custom_fields, :text unless column_exists?(:transportation_routes, :custom_fields)
  end
end
