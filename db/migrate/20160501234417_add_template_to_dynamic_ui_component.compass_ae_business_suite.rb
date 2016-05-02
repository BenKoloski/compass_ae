# This migration comes from compass_ae_business_suite (originally 20160119091918)
# This migration comes from compass_ae_business_suite (originally 20160119091918)
class AddTemplateToDynamicUiComponent < ActiveRecord::Migration
  def self.up
    add_column :dynamic_ui_components, :list_view_template, :text unless column_exists?(:dynamic_ui_components, :list_view_template)
    add_column :dynamic_ui_components, :detail_view_template, :text unless column_exists?(:dynamic_ui_components, :detail_view_template)
  end

  def self.down
    remove_column :dynamic_ui_components, :list_view_template
    remove_column :dynamic_ui_components, :detail_view_template
  end
end
