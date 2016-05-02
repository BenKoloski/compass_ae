# This migration comes from compass_ae_business_suite (originally 20160205005049)
class AddUnitOfMeasurementBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Unit of Measurement',
        internal_identifier: 'unit_of_measurement',
        data_manager_name: 'UnitOfMeasurement',
        root_model: 'UnitOfMeasurement',
        can_create: true,
        can_associate: false,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Unit of Measurement',
        title: 'UnitOfMeasurement',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js: {
            xtype: 'unitofmeasurementlistview'
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Unit of Measurement',
        title: 'Unit of Measurement',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
        ['Description', 'description', 'text', {}, locked: true],
        ['Internal Identifier', 'internal_identifier', 'text', {allow_blank: true, ext_js: {allowBlank: true}}, locked: false],
        ['Comments', 'comments', 'text', {allow_blank: true, ext_js: {allowBlank: true}}, locked: false],
        ['Domain', 'domain', 'text', {allow_blank: true, ext_js: {allowBlank: true}}, locked: false]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]
      locked = args[4]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: locked
                                             })

      field_definition.save

      field_definition.meta_data = meta_data
      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    #
    # Setup Organizer View Detail View Field Sets and List View
    #

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{description internal_identifier domain comments}.each do |field_iid|
      description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'unit_of_measurement', 'unit_of_measurement').destroy_all
  end
end
