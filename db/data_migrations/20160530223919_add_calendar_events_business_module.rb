class AddCalendarEventsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
      description: 'Calendar Events',
      internal_identifier: 'calendar_events',
      data_manager_name: 'CalendarEvents',
      root_model: 'CalendarEvent',
      can_create: true,
      can_associate: false,
      is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
      description: 'Calendar Events',
      title: 'CalendarEvents',
      icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
      can_edit_detail_view: true,
      can_edit_list_view: true
    )

    organizer_view.meta_data = {
      ext_js:{
        xtype: 'calendareventslistview'
      }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
      description: 'Calendar Events',
      title: 'Calendar Events',
      can_edit_detail_view: true,
      can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [

      ['Start Time', 'starttime', 'datetime', []],
      ['End Time', 'endtime', 'datetime', []],
      ['Service Provider', 'service_provider', 'business_party', []],
      ['Appointment Requester', 'appointment_requester', 'business_party', []],


    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      select_options = args[3]

      field_definition = FieldDefinition.new({
        field_name: field_name,
        label: label,
        field_type: FieldType.iid(field_type),
      })

      # add select options if they are present
      unless select_options.empty?
        field_definition.select_options = args[3]
      end

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
    %w{starttime endtime service_provider appointment_requester}.each do |field_iid|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      list_view_field.added_to_view = true
      list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    #
    # Setup Web View Detail View Field Sets and List View
    #

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{starttime endtime service_provider appointment_requester}.each do |field_iid|
      description_list_view_field = web_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    web_view.field_sets << details_field_set
    web_view.save

    #
    # Setup mobile view
    #

    mobile_view = MobileView.new(
        description: 'Calendar Events',
        title: 'Calendar Events',
        icon_src: '/assets/icons/default_mobile_app.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
        ['Description', 'description', 'text']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type)
                                             })

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

    %w{description}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

    %w{description}.each do |field_iid|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'calendar_events', 'calendar_events').destroy_all
  end
end
