# This migration comes from compass_ae_business_suite (originally 20150626215553)
class AddCustomFieldsToPaymentApplications < ActiveRecord::Migration
  def change
    add_column :payment_applications, :custom_fields, :text unless column_exists?(:payment_applications, :custom_fields)
  end
end
