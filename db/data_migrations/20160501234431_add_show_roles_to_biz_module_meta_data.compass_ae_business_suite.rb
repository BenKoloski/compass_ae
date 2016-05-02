# This migration comes from compass_ae_business_suite (originally 20150705185744)
class AddShowRolesToBizModuleMetaData < ActiveRecord::Migration
  def self.up
    bms = BusinessModule.where("is_template = 'f' and parent_module_type = 'business_party' and parent_id is null")
    bms.each do |bm|
      if bm.meta_data['show_roles'].nil?
        bm.meta_data['show_roles'] = false
        bm.meta_data['ext_js']['showRoles'] = false
        bm.save!
      end
    end
  end

  def self.down
    bms = BusinessModule.where("is_template = 'f' and parent_module_type = 'business_party' and parent_id is null")
    bms.each do |bm|
      unless (bm.meta_data['show_roles'].nil? and bm.meta_data['ext_js']['showRoles'].nil?)
        bm.meta_data.delete('show_roles') unless bm.meta_data['show_roles'].nil?
        bm.meta_data['ext_js'].delete('showRoles') unless bm.meta_data['ext_js']['showRoles'].nil?
        bm.save!
      end
    end
  end
end
