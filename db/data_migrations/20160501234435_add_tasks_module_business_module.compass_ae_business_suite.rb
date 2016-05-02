# This migration comes from compass_ae_business_suite (originally 20150711235605)
class AddTasksModuleBusinessModule
  def self.up

    # create the module
    new_module = BusinessModule.create(
      description: 'Tasks',
      internal_identifier: 'tasks',
      data_manager_name: 'Tasks',
      root_model: 'WorkEffort',
      can_create: true,
      can_associate: true,
      is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
      description: 'Tasks',
      title: 'Tasks',
      icon_src: '/assets/erp_app/business_modules/tasks/tasks.png',
      can_edit_detail_view: true,
      can_edit_list_view: true
    )

    organizer_view.meta_data = {
      ext_js: {}
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # add fields: field type should exist in FieldType or you'll get nil. Bad things will happen at run time
    [
      ['Name', 'description', 'text', true, {}],
      ['Type', 'work_effort_type', 'work_effort_type_field', false, {}],
      ['Long Description', 'long_description', 'rich_text_area', true, {}],
      ['Start', 'start_at', 'datetime', false, {}],
      ['End', 'end_at', 'datetime', false, {}],
      ['% Done', 'percent_done', 'percent', false, {}],
      ['Duration', 'duration', 'duration', false, {ext_js: {durationUnit: 'd'}}],
      ['Effort', 'effort', 'effort', false, {ext_js: {durationUnit: 'h'}}],
      ['Status', 'status', 'status', false, {parent_tracked_status_type_iid: 'task_statuses', ext_js: {parentTrackedStatusTypeIid: 'task_statuses'}}],
      ['Attachments', 'attachments', 'file_assets', false, {}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      locked = args[3]
      meta_data = args[4]

      field_definition = FieldDefinition.new({
                                               field_name: field_name,
                                               label: label,
                                               locked: locked,
                                               field_type: FieldType.iid(field_type)
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
                                       columns: 2
    })

    # add fields to field set
    %w{description work_effort_type status start_at end_at percent_done duration effort}.each do |field_iid|
      field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    %w{long_description attachments}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    # setup mobile view

    mobile_view = MobileView.new(
      description: 'Tasks',
      title: 'Tasks',
      icon_src: '',
      can_edit_detail_view: true,
      can_edit_list_view: true
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
      ['Name', 'description', 'text', true, {}],
      ['Type', 'work_effort_type', 'work_effort_type_field', false, {}],
      ['Long Description', 'long_description', 'rich_text_area', true, {}],
      ['Start', 'start_at', 'datetime', false, {}],
      ['End', 'end_at', 'datetime', false, {}],
      ['% Done', 'percent_done', 'percent', false, {}],
      ['Duration', 'duration', 'duration', false, {ext_js: {durationUnit: 'd'}}],
      ['Effort', 'effort', 'effort', false, {ext_js: {durationUnit: 'h'}}],
      ['Status', 'status', 'status', false, {parent_tracked_status_type_iid: 'task_statuses', ext_js: {parentTrackedStatusTypeIid: 'task_statuses'}}],
      ['Attachments', 'attachments', 'pictures', false, {}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      locked = args[3]
      meta_data = args[4]

      field_definition = FieldDefinition.new({
                                               field_name: field_name,
                                               label: label,
                                               locked: locked,
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

    %w{description work_effort_type start_at end_at percent_done duration effort status attachments}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

    %w{description}.each do |field_iid|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end

    # add watcher role type if it doesn't exist
    RoleType.find_or_create('watcher', 'Watcher', RoleType.iid('work_resource'))

    # add associated modules
    task_assignment_associator = CompassAeBusinessSuite::BusinessModules::Associator::TaskAssignment.new(new_module, {name: 'Resources'}, nil)
    task_assignment_module = task_assignment_associator.create_and_associate
    task_assignment_module.save!

    business_party_associator = CompassAeBusinessSuite::BusinessModules::Associator::BusinessParty.new(new_module, {name: 'Watchers', role_types: 'watcher'}, nil)
    watcher_module = business_party_associator.create_and_associate
    watcher_module.save!

    notes_associator = CompassAeBusinessSuite::BusinessModules::Associator::Notes.new(new_module, {name: 'Comments', note_type_ids: 'Comment'}, nil)
    notes_module = notes_associator.create_and_associate
    notes_module.save!

    # setup Web View
  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'tasks', 'tasks').destroy_all
  end
end
