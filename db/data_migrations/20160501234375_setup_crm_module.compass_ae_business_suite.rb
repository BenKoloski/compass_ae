# This migration comes from compass_ae_business_suite (originally 20140323173556)
class SetupCrmModule

  def self.up
    # create templates

    # create party modules template
    party_module = BusinessModule.create(
        description: 'Business Party',
        internal_identifier: 'business_party',
        data_manager_name: 'BusinessParty',
        root_model: 'Party',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    party_module.meta_data = {
        party_type: 'Individual',
        role_types: 'customer'
    }

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Party Organizer View Template',
        title: 'Party Organizer View Template',
        icon_src: '/assets/erp_app/shared/business_party_64x64.png'
    )
    organizer_view.meta_data = {
        ext_js: {
            roleTypes: 'customer',
            partyType: 'Individual'
        }
    }

    # setup web view
    web_view = WebView.new(
        description: 'Party Web View Template',
        title: 'Party Web View Template'
    )

    [
        ['Last Name', 'current_last_name', 'text'],
        ['First Name', 'current_first_name', 'text'],
        ['Middle Name', 'current_middle_name', 'text'],
        ['Title', 'current_title', 'text'],
        ['Suffix', 'current_suffix', 'text'],
        ['Nickname', 'current_nickname', 'text'],
        ['Gender', 'gender', 'radio', [{value: 'm', display: 'Male'}, {value: 'f', display: 'Female'}]],
        ['Birth Date', 'birth_date', 'date'],
        ['Height', 'height', 'number'],
        ['Weight', 'weight', 'number'],
        ['Mothers Maiden Name', 'mothers_maiden_name', 'text'],
        ['Marital Status', 'marital_status', 'radio', [{value: 's', display: 'Single'}, {value: 'm', display: 'Married'}]],
        ['Social Security Number', 'social_security_number', 'text'],
        ['Passport Number', 'current_passport_number', 'text'],
        ['Passport Expiration Date', 'current_passport_expire_date', 'date'],
        ['Total Years Work Experience', 'total_years_work_experience', 'number'],
        ['Description', 'description', 'text'],
        ['Tax ID', 'tax_id_number', 'text']
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

      if field_type == 'radio' || field_type == 'select'
        field_definition.select_options = args[3]
      end

      field_definition.save
      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 is_custom: is_custom,
                                                 field_type: FieldType.iid(field_type),
                                             })

      if field_type == 'radio' || field_type == 'select'
        field_definition.select_options = args[3]
      end

      field_definition.save
      web_view.add_available_field(field_definition, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    details_field_set = FieldSet.new(
        {
            field_set_name: 'name',
            label: 'Name',
            columns: 1
        }
    )

    description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', 'description').first
    description_list_view_field.added_to_view = true
    description_list_view_field.save

    details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', 'description').first, 1)
    details_field_set.save
    organizer_view.field_sets << details_field_set
    organizer_view.save

    party_module.dynamic_ui_components << organizer_view

    details_field_set = FieldSet.new(
        {
            field_set_name: 'name',
            label: 'Name',
            columns: 1
        }
    )

    description_list_view_field = web_view.available_list_view_fields.where('field_name = ?', 'description').first
    description_list_view_field.added_to_view = true
    description_list_view_field.save

    details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', 'description').first, 1)
    details_field_set.save
    web_view.field_sets << details_field_set
    web_view.save

    party_module.dynamic_ui_components << web_view

    party_module.save

    # setup mobile view

    mobile_view = MobileView.new(
        description: 'Business Party Mobile View Template',
        title: 'Business Party Mobile View Template',
        icon_src: '/assets/erp_app/icons/business_party_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )
    mobile_view.save

    party_module.dynamic_ui_components << mobile_view

    [
        ['Description', 'description', 'text'],
        ['Last Name', 'current_last_name', 'text'],
        ['First Name', 'current_first_name', 'text'],
        ['Middle Name', 'current_middle_name', 'text'],
        ['Pictures', 'pictures', 'pictures']
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

    %w{description current_last_name current_first_name current_middle_name pictures}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

    %w{description}.each do |field_iid|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end

    # create customer module and add to CRM application
    crm = Application.find_by_internal_identifier('crm')

    customers_module = party_module.clone
    customers_module.internal_identifier = 'customers'
    customers_module.description = 'Customers'
    customers_module.dynamic_ui_components.update_description('Customers')
    customers_module.dynamic_ui_components.update_title('Customers')

    crm.modules << customers_module
    crm.save

    organizer_view = customers_module.organizer_view
    organizer_view.description = 'Customers'
    organizer_view.title = 'Customers'
    organizer_view.meta_data['ext_js'].merge!({partyRole: 'customer'})
    organizer_view.save

  end

  def self.down
    #remove data here
  end

end
