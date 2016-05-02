# This migration comes from erp_tech_svcs (originally 20160122155402)
class AddDescriptionToFileAsset < ActiveRecord::Migration
  def up
    unless column_exists? :file_assets, :description
      add_column :file_assets, :description, :string
    end
  end

  def down
    if column_exists? :file_assets, :description
      remove_column :file_assets, :description
    end
  end
end
