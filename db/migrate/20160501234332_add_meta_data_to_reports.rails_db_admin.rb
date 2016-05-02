# This migration comes from rails_db_admin (originally 20150926061259)
class AddMetaDataToReports < ActiveRecord::Migration
  def up
    add_column :reports, :meta_data, :text unless column_exists? :reports, :meta_data
  end

  def down
    remove_column :reports, :meta_data if column_exists? :reports, :meta_data
  end
end
