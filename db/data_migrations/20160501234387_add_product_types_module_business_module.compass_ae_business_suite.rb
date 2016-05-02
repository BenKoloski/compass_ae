# This migration comes from compass_ae_business_suite (originally 20141127045819)
class AddProductTypesModuleBusinessModule

  def self.up

    # create the module
    products_module = BusinessModule.create(
        description: 'Product Types',
        internal_identifier: 'product_types',
        data_manager_name: 'ProductTypes',
        root_model: 'ProductType',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Product Types',
        title: 'Product Types',
        icon_src: '/assets/erp_app/shared/product_types_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {ext_js: {}}
    products_module.dynamic_ui_components << organizer_view
    products_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Product Types',
        title: 'Product Types',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    products_module.dynamic_ui_components << web_view
    products_module.save

    # add fields
    [
        ['Description', 'description', 'text'],
        ['Internal Identifier', 'internal_identifier', 'text'],
        ['Category', 'category', 'category'],
        ['GL Account', 'gl_account', 'gl_account'],
        ['Price', 'price', 'price'],
        ['Cost', 'cost', 'money'],
        ['Cylindrical', 'cylindrical', 'yes_no'],
        ['Length (in)', 'length', 'number'],
        ['Width (in)', 'width', 'number'],
        ['Height (in)', 'height', 'number'],
        ['Weight (lbs)', 'weight', 'number'],
        ['Available On Web', 'available_on_web', 'yes_no'],
        ['Taxable', 'taxable', 'yes_no'],
        ['Main Image', 'main_image', 'image']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: true
                                             })

      field_definition.save

      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :list)

    end

    # add fields to field set
    %w{description internal_identifier category gl_account price cost}.each do |field_iid|
      field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      field = web_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save
    end

    #
    # Add Services Sub Module
    #

    # create the module
    services_module = BusinessModule.create(
        description: 'Services',
        internal_identifier: 'product_types_services',
        data_manager_name: 'ProductTypes',
        parent_module_type: 'product_types',
        root_model: 'ProductType',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Services',
        title: 'Services',
        icon_src: '/assets/erp_app/shared/product_types_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {ext_js: {}}
    services_module.dynamic_ui_components << organizer_view
    services_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Services',
        title: 'Services',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    services_module.dynamic_ui_components << web_view
    services_module.save

    # add fields
    [
        ['Description', 'description', 'text'],
        ['Internal Identifier', 'internal_identifier', 'text'],
        ['Category', 'category', 'category'],
        ['GL Account', 'gl_account', 'gl_account'],
        ['Price', 'price', 'price'],
        ['Cost', 'cost', 'money'],
        ['Taxable', 'taxable', 'yes_no']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: true
                                             })

      field_definition.save

      # add to other views
      organizer_view.add_available_field(field_definition, :detail)
      web_view.add_available_field(field_definition.dup, :detail)

    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{description internal_identifier category gl_account price cost taxable}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 1
                                     })

    # add fields to field set
    %w{description internal_identifier category gl_account price cost taxable}.each do |field_iid|
      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    web_view.field_sets << details_field_set
    web_view.save

    services_module.move_to_child_of(products_module)

    #
    # Add Items Sub Module
    #

    # create the module
    items_module = BusinessModule.create(
        description: 'Items',
        internal_identifier: 'product_types_items',
        data_manager_name: 'ProductTypes',
        root_model: 'ProductType',
        parent_module_type: 'product_types',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Items',
        title: 'Items',
        icon_src: '/assets/erp_app/shared/product_types_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {ext_js: {}}
    items_module.dynamic_ui_components << organizer_view
    items_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Items',
        title: 'Items',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    items_module.dynamic_ui_components << web_view
    items_module.save

    # add fields
    [
        ['Description', 'description', 'text'],
        ['Internal Identifier', 'internal_identifier', 'text'],
        ['Category', 'category', 'category'],
        ['Price', 'price', 'price'],
        ['GL Account', 'gl_account', 'gl_account'],
        ['Cost', 'cost', 'money'],
        ['Cylindrical', 'cylindrical', 'yes_no'],
        ['Length (in)', 'length', 'number'],
        ['Width (in)', 'width', 'number'],
        ['Height (in)', 'height', 'number'],
        ['Weight (lbs)', 'weight', 'number'],
        ['Unit Of Measure', 'unit_of_measurement', 'unit_of_measurement'],
        ['Available On Web', 'available_on_web', 'yes_no'],
        ['Taxable', 'taxable', 'yes_no'],
        ['Main Image', 'main_image', 'image']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: true
                                             })

      field_definition.save

      # add to other views
      organizer_view.add_available_field(field_definition, :detail)
      web_view.add_available_field(field_definition.dup, :detail)

    end

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 2
                                     })

    # add fields to field set
    %w{description internal_identifier category gl_account price cost taxable available_on_web}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    %w{main_image}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    dimensions_field_set = FieldSet.new({
                                            field_set_name: 'dimensions',
                                            label: 'Dimensions',
                                            columns: 2
                                        })

    %w{unit_of_measurement width height}.each do |field_iid|
      dimensions_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      dimensions_field_set.save
    end

    %w{length weight cylindrical}.each do |field_iid|
      dimensions_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      dimensions_field_set.save
    end

    organizer_view.field_sets << dimensions_field_set
    organizer_view.save

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 2
                                     })

    # add fields to field set
    %w{description internal_identifier category gl_account price cost taxable available_on_web}.each do |field_iid|
      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    %w{main_image}.each do |field_iid|
      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      details_field_set.save
    end

    web_view.field_sets << details_field_set
    web_view.save

    dimensions_field_set = FieldSet.new({
                                            field_set_name: 'dimensions',
                                            label: 'Dimensions',
                                            columns: 2
                                        })

    %w{width height}.each do |field_iid|
      dimensions_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      dimensions_field_set.save
    end

    %w{length weight cylindrical}.each do |field_iid|
      dimensions_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      dimensions_field_set.save
    end

    web_view.field_sets << dimensions_field_set
    web_view.save

    items_module.move_to_child_of(products_module)
  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'product_types', 'product_types').destroy_all
  end
end
