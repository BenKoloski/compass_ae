# This migration comes from compass_ae_business_suite (originally 20150405185949)
class AddShowInMenuToModules < ActiveRecord::Migration

  def self.up
    business_modules = BusinessModule.where("is_template = 'f'")
    business_modules.each do |business_module|
      business_module.meta_data['show_in_menu'] = true
      business_module.meta_data['ext_js'] = {} unless business_module.meta_data['ext_js']
      business_module.meta_data['ext_js']['showInMenu'] = true
      business_module.save!
    end
  end

  def self.down
  

  end

end
