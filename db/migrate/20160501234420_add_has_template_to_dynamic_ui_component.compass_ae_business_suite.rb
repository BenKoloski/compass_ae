# This migration comes from compass_ae_business_suite (originally 20160304094043)
class AddHasTemplateToDynamicUiComponent < ActiveRecord::Migration
  def self.up
    remove_column :dynamic_ui_components, :list_view_template if column_exists?(:dynamic_ui_components, :list_view_template)
    remove_column :dynamic_ui_components, :detail_view_template if column_exists?(:dynamic_ui_components, :detail_view_template)
    add_column :dynamic_ui_components, :has_list_view_template, :boolean unless column_exists?(:dynamic_ui_components, :has_list_view_template)
    add_column :dynamic_ui_components, :has_detail_view_template, :boolean unless column_exists?(:dynamic_ui_components, :has_detail_view_template)
  end

  def self.down
    remove_column :dynamic_ui_components, :has_list_view_template if column_exists?(:dynamic_ui_components, :has_list_view_template)
    remove_column :dynamic_ui_components, :has_detail_view_template if column_exists?(:dynamic_ui_components, :has_detail_view_template)
  end
end
