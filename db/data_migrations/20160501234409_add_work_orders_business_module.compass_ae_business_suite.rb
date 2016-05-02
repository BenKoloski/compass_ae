# This migration comes from compass_ae_business_suite (originally 20150226164700)
class AddWorkOrdersBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Work Orders',
        internal_identifier: 'work_orders',
        data_manager_name: 'Orders',
        root_model: 'OrderTxn',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Work Orders',
        title: 'Work Orders',
        icon_src: '/assets/erp_app/shared/work_orders_64x64.png',
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
        description: 'Work Orders',
        title: 'Work Orders',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
        ['Description', 'description', 'text', {}],
        ['Work Order Number', 'order_number', 'text', {}],
        ['Status', 'status', 'status', {parent_tracked_status_type_iid: 'work_order_statuses', ext_js:{parentTrackedStatusTypeIid: 'work_order_statuses'}}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]
      is_locked = args[4]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 locked: is_locked,
                                                 label: label,
                                                 is_custom: false,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.save

      field_definition.meta_data = meta_data
      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    # setup field sets
    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 2
                                     })


    # add fields to detail field set first column
    %w{order_number description status}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    # add list fields
    %w{order_number description status}.each do |field_iid|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      list_view_field.added_to_view = true
      list_view_field.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save


    # mobile view

    mobile_view = MobileView.new(
        description: 'Work Orders',
        title: 'Work Orders',
        icon_src: '/assets/erp_app/shared/work_orders_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
        ['Order Number', 'order_number', 'text', {}, :both],
        ['Status', 'status', 'status', {parent_tracked_status_type_iid: 'order_statuses', ext_js: {parentTrackedStatusTypeIid: 'order_statuses'}}, :both]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]
      view = args[4]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 locked: true,
                                                 field_type: FieldType.iid(field_type)
                                             })

      field_definition.save
      field_definition.meta_data = meta_data
      field_definition.save

      if view == :detail || view == :both
        mobile_view.add_available_field(field_definition, :detail)
      end

      if view == :both
        mobile_view.add_available_field(field_definition.dup, :list)
      end
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
            columns: 2
        }
    )

    mobile_view.field_sets << mobile_list_view
    mobile_view.save

    [['order_number', 1], ['status', 2]].each do |field|
      iid = field[0]
      column = field[1]

      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', iid).first, column)
      mobile_list_view.save
    end

    %w{order_number status}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

  end

  def self.down
    BusinessModule.where('data_manager_name = ?', 'WorkOrders').destroy_all
  end
end