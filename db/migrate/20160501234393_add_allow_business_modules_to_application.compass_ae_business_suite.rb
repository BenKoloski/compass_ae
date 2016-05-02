# This migration comes from compass_ae_business_suite (originally 20150217014134)
class AddAllowBusinessModulesToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :allow_business_modules, :boolean, :default => true unless column_exists?(:applications, :allow_business_modules)
    add_index :applications, :allow_business_modules, :name => 'applications_allow_biz_modules_idx' unless index_exists?(:applications, :allow_business_modules, name: 'applications_allow_biz_modules_idx')
  end
end
