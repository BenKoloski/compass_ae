# This migration comes from compass_ae_business_suite (originally 20141217154046)
class AddOrderLineItemsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Order Line Items',
        internal_identifier: 'order_line_items',
        data_manager_name: 'OrderLineItems',
        root_model: 'OrderLineItem',
        can_create: false,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'OrderLineItems Organizer Template',
        title: 'OrderLineItems Organizer Template',
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
        description: 'OrderLineItems Web View Template',
        title: 'OrderLineItems Web View Template',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
        ['Product Type', 'product_type', 'product_type'],
        ['Quantity', 'quantity', 'number'],
        ['Price', 'sold_price', 'money'],
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 locked: true,
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{product_type sold_price quantity}.each do |field_iid|
      list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      list_view_field.added_to_view = true
      list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    # Add Invoice Items to Invoices template
    orders = BusinessModule.templates.where('internal_identifier = ?', 'orders').first
    order_items_associator = CompassAeBusinessSuite::BusinessModules::Associator::OrderLineItems.new(orders, {name: 'Items'}, nil)
    order_items_module = order_items_associator.create_and_associate
    order_items_module.organizer_view.position = 0
    order_items_module.organizer_view.save!
    order_items_module.save!

    payment_associator = CompassAeBusinessSuite::BusinessModules::Associator::PaymentApplication.new(orders, {name: 'Payments'}, nil)
    payment_module = payment_associator.create_and_associate
    payment_module.organizer_view.position = 1
    payment_module.organizer_view.save!
    payment_module.save!
  end

  def self.down
    BusinessModule.where('root_model = ?', 'OrderLineItem').destroy_all
  end
end
