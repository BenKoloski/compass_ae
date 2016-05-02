# This migration comes from compass_ae_business_suite (originally 20141223214618)
class AddFilesModuleBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Files',
        internal_identifier: 'files',
        data_manager_name: 'Files',
        root_model: 'FileAsset',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Files Organizer Template',
        title: 'Files Organizer Template',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
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
        description: 'Files Web View Template',
        title: 'Files Web View Template',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
        ['File', 'file', 'file'],
        ['Description', 'description', 'text'],
        ['Tags', 'tags', 'tags']
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

      # add to other views
      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{file description tags}.each do |field_iid|
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
  end
end
