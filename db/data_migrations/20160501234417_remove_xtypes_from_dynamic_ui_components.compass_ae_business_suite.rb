# This migration comes from compass_ae_business_suite (originally 20150324155345)
class RemoveXtypesFromDynamicUiComponents < ActiveRecord::Migration
  def self.up

    ducs = DynamicUiComponent.where("meta_data like '%listview%'")
    ducs.each do |duc|
      duc.meta_data["ext_js"].delete("xtype")
      duc.save!
    end

  end

  def self.down
  end
end
