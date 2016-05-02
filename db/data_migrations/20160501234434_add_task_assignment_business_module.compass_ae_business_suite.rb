# This migration comes from compass_ae_business_suite (originally 20150711235604)
class AddTaskAssignmentBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Task Assignment',
        internal_identifier: 'task_assignment',
        data_manager_name: 'TaskAssignment',
        root_model: 'WorkEffortPartyAssignment',
        can_create: false,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Task Assignment',
        title: 'TaskAssignment',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js: {
            xtype: 'taskassignmentlistview'
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # add work resource role type if it doesn't exist
    RoleType.find_or_create('work_resource', 'Work Resource', RoleType.iid('application_composer'))

    task_resource_statuses = TrackedStatusType.find_or_create('task_resource_statuses', 'Task Resource Statuses')
    TrackedStatusType.find_or_create('task_resource_status_pending', 'Pending').move_to_child_of(task_resource_statuses)
    TrackedStatusType.find_or_create('task_resource_status_in_transit', 'In Transit').move_to_child_of(task_resource_statuses)
    TrackedStatusType.find_or_create('task_resource_status_in_progress', 'In Progress').move_to_child_of(task_resource_statuses)
    TrackedStatusType.find_or_create('task_resource_status_hold', 'Hold').move_to_child_of(task_resource_statuses)
    TrackedStatusType.find_or_create('task_resource_status_complete', 'Complete').move_to_child_of(task_resource_statuses)

    # add fields
    [
        ['Resource', 'resource', 'business_party', {role_types: 'work_resource', ext_js: {roleTypes: 'work_resource'}}],
        ['Allocation', 'resource_allocation', 'percent', {}],
        ['Status', 'status', 'status', {parent_tracked_status_type_iid: 'task_resource_statuses', ext_js: {parentTrackedStatusTypeIid: 'task_resource_statuses'}}],
        ['Comments', 'comments', 'rich_text_area', {}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 locked: true,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.save

      field_definition.meta_data = meta_data
      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 2
                                     })

    # add fields to field set
    %w{resource resource_allocation status}.each do |field_iid|
      description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    %w{comments}.each do |field_iid|
      description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    # setup mobile view

    mobile_view = MobileView.new(
        description: 'Task Assignment',
        title: 'Task Assignment',
        icon_src: '/assets/icons/default_mobile_app.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
        ['Resource', 'resource', 'business_party', {role_types: 'work_resource', ext_js: {roleTypes: 'work_resource'}}],
        ['Status', 'status', 'status', {parent_tracked_status_type_iid: 'task_resource_statuses', ext_js: {parentTrackedStatusTypeIid: 'task_resource_statuses'}}],
        ['Allocation', 'resource_allocation', 'percent', {}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 locked: true,
                                                 field_type: FieldType.iid(field_type)
                                             })

      field_definition.save

      field_definition.meta_data = meta_data
      field_definition.save

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

    %w{resource resource_allocation status}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save

      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end

  end

  def self.down
    BusinessModule.where('internal_identifier = ?', 'task_assignment').destroy_all
  end
end
