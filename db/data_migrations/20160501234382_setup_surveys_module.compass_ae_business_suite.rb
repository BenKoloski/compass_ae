# This migration comes from compass_ae_business_suite (originally 20140710104403)
class SetupSurveysModule

  def self.up
=begin

#### Commented out for now until it is built out.

    surveys_module = BusinessModule.create(
        description: 'Surveys',
        internal_identifier: 'surveys',
        data_manager_name: 'Surveys',
        root_model: 'Survey',
        can_associate: true,
        is_template: true
    )


    organizer_view = OrganizerView.new(
        description: 'Surveys Organizer Template',
        title: 'Surveys Organizer Template',
        icon_src: '/assets/erp_app/icons/notes_64x64.png',
    )

    organizer_view.meta_data = {
        ext_js: {
            baseURL: '/erp_app/organizer/crm/surveys',
            title: 'Survey',
            addBtnDescription: 'Create Survey',
            searchDescription: 'Find Survey'
        }
    }

    web_view = WebView.new(
        description: 'Surveys Web View Template',
        title: 'Surveys Web View Template',
    )

    

    [
        ['Description', 'description', 'text'],
        ['Score', 'score', 'text'],
        ['Created At', 'created_at', 'date'],
        ['Updated At', 'updated_at', 'date']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      is_custom = !!args[4]
      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 is_custom: is_custom,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.save
      organizer_view.add_available_field(field_definition, 'list')

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 is_custom: is_custom,
                                                 field_type: FieldType.iid(field_type),
                                             })
      field_definition.save
      web_view.add_available_field(field_definition, 'list')
    end

    details_field_set = FieldSet.new(
        {
            field_set_name: 'questions',
            label: 'Questions',
            columns: 2
        }
    )

    ['description', 'score', 'created_at', 'updated_at'].each do |field|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field).first
      list_view_field.added_to_view = true
      list_view_field.save
    end

    details_field_set.save
    organizer_view.field_sets << details_field_set
    organizer_view.save

    surveys_module.dynamic_ui_components << organizer_view
    surveys_module.save


    details_field_set = FieldSet.new(
        {
            field_set_name: 'questions',
            label: 'Questions',
            columns: 2
        }
    )

    ['description', 'score', 'created_at', 'updated_at'].each do |field|
      list_view_field = web_view.available_list_view_fields.where('field_name = ?', field).first
      list_view_field.added_to_view = true
      list_view_field.save
    end

    details_field_set.save
    web_view.field_sets << details_field_set
    web_view.save
    

    surveys_module.dynamic_ui_components << web_view
    surveys_module.save

=end

  end

  def self.down
    #remove data here
  end

end
