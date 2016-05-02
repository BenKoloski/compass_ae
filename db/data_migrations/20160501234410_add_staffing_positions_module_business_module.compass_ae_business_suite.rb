# This migration comes from compass_ae_business_suite (originally 20150227175005)
class AddStaffingPositionsModuleBusinessModule
  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Staffing Positions',
        internal_identifier: 'staffing_positions',
        data_manager_name: 'StaffingPositions',
        root_model: 'StaffingPosition',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'StaffingPositions Organizer Template',
        title: 'StaffingPositions Organizer Template',
        icon_src: '/assets/erp_app/shared/product_types_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
        description: 'StaffingPositions Web View Template',
        title: 'StaffingPositions Web View Template',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields: field type should exist in FieldType or you'll get nil. Bad things will happen at run time
    [
        ['Description', 'description', 'text']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: false
                                             })

      field_definition.save

      # add to other views
      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)

    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 2
                                     })

    # add fields to field set
    %w{description}.each do |field_iid|
      field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end


    organizer_view.field_sets << details_field_set
    organizer_view.save

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'staffing_positions', 'staffing_positions').destroy_all
  end
end
