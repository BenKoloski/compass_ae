# This migration comes from compass_ae_business_suite (originally 20150309122534)
class AddWcCodeFieldToWorkOrder < ActiveRecord::Migration
  def self.up

    # find the business_module for work_orders
    work_order_modules = BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'work_orders', 'work_orders')

    # add  wc code field to each of the work order modules views
    work_order_modules.each do |work_order_module|

      # create a field definition for 'wc code'
      field_definition = FieldDefinition.new({
                                                 field_name: 'wc_code',
                                                 locked: false,
                                                 label: 'WC Code',
                                                 is_custom: true,
                                                 field_type: FieldType.iid('wc_code')
                                             })
      field_definition.save

      work_order_module.organizer_view.add_available_field(field_definition, :detail)
      work_order_module.organizer_view.add_available_field(field_definition.dup, :list)
      work_order_module.web_view.add_available_field(field_definition.dup, :detail)
      work_order_module.web_view.add_available_field(field_definition.dup, :list)

      # find the field set to add to and add to it
      details_field_set = work_order_module.organizer_view.field_sets.first
      details_field_set.add_field(work_order_module.organizer_view.available_detail_view_fields.where('field_name = ?', 'wc_code').first, 1)
      details_field_set.save

      # (OPTIONAL) add to list view, web view, and mobile view
    end

  end

  def self.down
    work_order_modules = BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'work_orders', 'work_orders').destroy_all

    work_order_modules.each do |work_order_module|

      field_definitions = work_order_module.all_fields_by_name('wc_code')

      field_definitions.each do |field_definition|
        if field_definition.field_name == 'wc_code'
          field_definition.delete
        end
      end

    end


  end
end