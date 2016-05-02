# This migration comes from compass_ae_business_suite (originally 20151218202104)
class AddTripsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Trips',
        internal_identifier: 'trips',
        data_manager_name: 'Trips',
        root_model: 'TransportationRoute',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Trips',
        title: 'Trips',
        icon_src: '/assets/erp_app/business_modules/trips/trips.png',
        can_edit_detail_view: true,
        can_edit_list_view: false
    )

    organizer_view.meta_data = {
        ext_js: {
            xtype: 'tripslistview'
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Trips',
        title: 'Trips',
        can_edit_detail_view: true,
        can_edit_list_view: false
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    trip_statuses = TrackedStatusType.find_or_create('trip_statuses', 'Trip Statuses')
    TrackedStatusType.find_or_create('trip_statuses_pending', 'Pending').move_to_child_of(trip_statuses)
    TrackedStatusType.find_or_create('trip_statuses_approved', 'Approved').move_to_child_of(trip_statuses)
    TrackedStatusType.find_or_create('trip_statuses_expensed', 'Expensed').move_to_child_of(trip_statuses)
    TrackedStatusType.find_or_create('trip_statuses_invoiced', 'Invoiced').move_to_child_of(trip_statuses)

    # add fields
    [
        ['Description', 'description', 'text', {}],
        ['Date', 'actual_start', 'date', {}],
        ['Miles', 'miles_traveled', 'number', {}],
        ['Billable', 'billable', 'yes_no', {default_value: 'no'}],
        ['Status', 'status', 'status',  {parent_tracked_status_type_iid: 'trip_statuses', ext_js: {parentTrackedStatusTypeIid: 'trip_statuses'}}],
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

      field_definition.meta_data = meta_data

      field_definition.save!

      organizer_view.add_available_field(field_definition, :detail)
      web_view.add_available_field(field_definition.dup, :detail)
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
    %w{description actual_start miles_traveled billable status}.each do |field_iid|
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
    %w{description actual_start miles_traveled billable status}.each do |field_iid|
      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    web_view.field_sets << details_field_set
    web_view.save

    #
    # Setup mobile view
    #

    mobile_view = MobileView.new(
        description: 'Trips',
        title: 'Trips',
        icon_src: '/assets/icons/default_mobile_app.png',
        can_edit_detail_view: true,
        can_edit_list_view: false
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
        ['Description', 'description', 'text'],
        ['Date', 'actual_start', 'date'],
        ['Miles', 'miles_traveled', 'number'],
        ['Billable', 'billable', 'yes_no', {default_value: 'no'}],
        ['Status', 'status', 'status',  {parent_tracked_status_type_iid: 'trip_statuses', ext_js: {parentTrackedStatusTypeIid: 'trip_statuses'}}],
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

      field_definition.meta_data = meta_data

      field_definition.save!

      mobile_view.add_available_field(field_definition, :detail)
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

    %w{status billable miles_traveled actual_start description }.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'trips', 'trips').destroy_all
  end
end
