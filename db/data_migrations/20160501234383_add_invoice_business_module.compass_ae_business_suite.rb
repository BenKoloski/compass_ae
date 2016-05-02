# This migration comes from compass_ae_business_suite (originally 20140929191916)
class AddInvoiceBusinessModule

  def self.up
    # create the module
    invoice_module = BusinessModule.create(
        description: 'Invoicing',
        internal_identifier: 'invoicing',
        data_manager_name: 'Invoicing',
        root_model: 'Invoice',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Invoicing Organizer Template',
        title: 'Invoicing Organizer Template',
        icon_src: '/assets/erp_app/shared/invoicing_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }
    invoice_module.dynamic_ui_components << organizer_view
    invoice_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Invoicing Web View Template',
        title: 'Invoicing Web View Template',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    invoice_module.dynamic_ui_components << web_view
    invoice_module.save

    invoice_statuses = TrackedStatusType.find_or_create('invoice_statuses', 'Invoice Statuses')

    TrackedStatusType.find_or_create('invoice_statuses_open', 'Open', invoice_statuses)
    TrackedStatusType.find_or_create('invoice_statuses_hold', 'Hold', invoice_statuses)
    TrackedStatusType.find_or_create('invoice_statuses_sent', 'Sent', invoice_statuses)
    TrackedStatusType.find_or_create('invoice_statuses_closed', 'Closed', invoice_statuses)

    # add fields
    [
        ['Customer', 'customer', 'business_party', {role_types: 'customer', ext_js: {roleTypes: 'customer'}}],
        ['Description', 'description', 'text', {}],
        ['Invoice Number', 'invoice_number', 'text', {}],
        ['Invoice Date', 'invoice_date', 'date', {}],
        ['Due Date', 'due_date', 'date', {}],
        ['Terms', 'terms', 'text', {}],
        ['Balance', 'balance', 'money', {}],
        ['Status', 'status', 'status',  {parent_tracked_status_type_iid: 'invoice_statuses', ext_js: {parentTrackedStatusTypeIid: 'invoice_statuses'}}]
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
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    details_field_set = FieldSet.new(
        {
            field_set_name: 'details',
            label: 'Details',
            columns: 1
        }
    )

    # add fields to field set
    %w{customer description invoice_number invoice_date due_date terms balance status}.each do |field_iid|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      list_view_field.added_to_view = true
      list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
      organizer_view.field_sets << details_field_set
      organizer_view.save
    end
  end

  def self.down
    BusinessModule.where('internal_identifier = ?', 'invoicing').destroy_all
    BusinessModule.where('parent_module_type = ?', 'invoicing').destroy_all
  end

end
