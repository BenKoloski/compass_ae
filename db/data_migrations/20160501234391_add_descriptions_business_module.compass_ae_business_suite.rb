# This migration comes from compass_ae_business_suite (originally 20141222193749)
class AddDescriptionsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Descriptions',
        internal_identifier: 'descriptions',
        data_manager_name: 'Descriptions',
        root_model: 'DescriptiveAsset',
        can_create: false,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Descriptions Organizer Template',
        title: 'Descriptions Organizer Template',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
        can_edit_detail_view: false,
        can_edit_list_view: false
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # add fields
    [
        ['View', 'view_type', 'view_type'],
        ['Description', 'description', 'rich_text_area'],
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 locked: true,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', 'view_type').first
    description_list_view_field.added_to_view = true
    description_list_view_field.save

    # add fields to field set
    %w{view_type description}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

  end

  def self.down
  end
end
