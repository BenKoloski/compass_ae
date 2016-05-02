# This migration comes from compass_ae_business_suite (originally 20150121143214)
class AddInvoiceItemsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Invoice Items',
        internal_identifier: 'invoice_items',
        data_manager_name: 'InvoiceItems',
        root_model: 'InvoiceItem',
        can_create: false,
        can_associate: true,
        is_template: true
    )

    new_module.meta_data = {
        sales_tax_rate: 0.07,
        ext_js: {
            salesTaxRate: 0.07
        }
    }
    new_module.save

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'InvoiceItems Organizer Template',
        title: 'InvoiceItems Organizer Template',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
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
        description: 'InvoiceItems Web View Template',
        title: 'InvoiceItems Web View Template',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields to both views
    [
        ['Description', 'item_description', 'text'],
        ['Product Type', 'product_type', 'product_type'],
        ['Rate', 'unit_price', 'money'],
        ['Quantity', 'quantity', 'number'],
        ['Taxable', 'taxable', 'yes_no'],
        ['Sales Tax Rate', 'tax_rate', 'number'],
        ['Sales Tax', 'sales_tax', 'display'],
        ['Amount', 'amount', 'display']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 locked: true,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    # setup detail view
    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{item_description product_type unit_price quantity amount taxable tax_rate sales_tax}.each do |field_iid|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      list_view_field.added_to_view = true
      list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    # Add Invoice Items to Invoices template
    invoicing = BusinessModule.templates.where('internal_identifier = ?', 'invoicing').first
    invoice_items_associator = CompassAeBusinessSuite::BusinessModules::Associator::InvoiceItems.new(invoicing, {name: 'Items', tax_rate: '0.07'}, nil)
    invoice_items_module = invoice_items_associator.create_and_associate
    invoice_items_module.organizer_view.position = 0
    invoice_items_module.organizer_view.save!
    invoice_items_module.save!

  end

  def self.down
    BusinessModule.where('root_model = ?', 'InvoiceItem').destroy_all
  end
end
