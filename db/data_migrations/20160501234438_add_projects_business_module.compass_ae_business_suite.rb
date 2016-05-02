# This migration comes from compass_ae_business_suite (originally 20150718053804)
class AddProjectsBusinessModule
  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Projects',
        internal_identifier: 'projects',
        data_manager_name: 'Projects',
        root_model: 'Project',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Projects',
        title: 'Projects',
        icon_src: '/assets/erp_app/business_modules/projects/projects.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # add fields: field type should exist in FieldType or you'll get nil. Bad things will happen at run time
    [
        ['Description', 'description', 'text'],
        ['Status', 'status', 'status', {parent_tracked_status_type_iid: 'project_statuses', ext_js:{parentTrackedStatusTypeIid: 'project_statuses'}}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: false
                                             })

      field_definition.save
      if meta_data
        field_definition.meta_data = meta_data
        field_definition.save
      end

      # add to other views
      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)

    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{description status}.each do |field_iid|
      field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    # setup mobile view

    mobile_view = MobileView.new(
        description: 'Projects',
        title: 'Projects',
        icon_src: '',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
        ['Description', 'description', 'text'],
        ['Status', 'status', 'status', {parent_tracked_status_type_iid: 'project_statuses', ext_js:{parentTrackedStatusTypeIid: 'project_statuses'}}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type)
                                             })

      field_definition.save
      if meta_data
        field_definition.meta_data = meta_data
        field_definition.save
      end

      mobile_view.add_available_field(field_definition, :detail)
      mobile_view.add_available_field(field_definition.dup, :list)
    end

    mobile_detail_view = FieldSet.new(
        {
            field_set_name: 'mobile_detail_view',
            label: 'Mobile Detail View',
            columns: 1
        }
    )

    mobile_view.field_sets << mobile_detail_view
    mobile_view.save

    mobile_list_view = FieldSet.new(
        {
            field_set_name: 'mobile_list_view',
            label: 'Mobile List View',
            columns: 1
        }
    )

    mobile_view.field_sets << mobile_list_view
    mobile_view.save

    %w{description status}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

    %w{description status}.each do |field_iid|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end

    # add associated modules
    business_party_associator = CompassAeBusinessSuite::BusinessModules::Associator::Tasks.new(new_module, {name: 'Tasks'}, nil)
    business_party_module = business_party_associator.create_and_associate
    business_party_module.save!

    notes_associator = CompassAeBusinessSuite::BusinessModules::Associator::Notes.new(new_module, {name: 'Comments', note_type_ids: 'Comment'}, nil)
    notes_module = notes_associator.create_and_associate
    notes_module.save!
  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'projects', 'projects').destroy_all
  end
end
