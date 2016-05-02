# This migration comes from compass_ae_business_suite (originally 20140929191917)
class AddPaymentApplicationModule

  def self.up
    # create the module
    new_module = BusinessModule.create(
        description: 'Payments',
        internal_identifier: 'payment_application',
        data_manager_name: 'PaymentApplication',
        root_model: 'PaymentApplication',
        can_associate: true,
        can_create: false,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Payment Application Organizer Template',
        title: 'Payment Application Organizer Template',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
        can_edit_detail_view: false,
        can_edit_list_view: false
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Payment Application Web View Template',
        title: 'Payment Application Web View Template',
        can_edit_detail_view: false,
        can_edit_list_view: true
    )

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
        ['Description', 'description', 'text'],
        ['Status', 'status', 'text'],
        ['Reference Number', 'reference_number', 'text'],
        ['Amount', 'amount', 'display'],
        ['Payment Type', 'payment_type', 'text'],
        ['Created At', 'created_at', 'date']
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

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    # add fields to field set
    %w{description payment_type reference_number amount created_at status}.each do |field_iid|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      list_view_field.added_to_view = true
      list_view_field.save
    end

    # Add Payments to Invoices template
    invoicing = BusinessModule.templates.where('internal_identifier = ?', 'invoicing').first
    payment_associator = CompassAeBusinessSuite::BusinessModules::Associator::PaymentApplication.new(invoicing, {name: 'Payments'}, nil)
    payment_module = payment_associator.create_and_associate
    payment_module.organizer_view.position = 1
    payment_module.organizer_view.save!
    payment_module.save!
  end

  def self.down
    BusinessModule.where('root_model = ?', 'PaymentApplication').destroy_all
  end

end
