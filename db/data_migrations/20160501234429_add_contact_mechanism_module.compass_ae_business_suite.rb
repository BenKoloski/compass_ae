# This migration comes from compass_ae_business_suite (originally 20150608184621)
class AddContactMechanismModule

  def self.up
    # create Contact Mechanism Module
    contact_mechanism_module = BusinessModule.create(
        description: 'Contact Mechanisms',
        internal_identifier: 'contact_mechanism',
        data_manager_name: 'ContactMechanism',
        root_model: 'Contact',
        can_create: false,
        can_associate: true,
        is_template: true
    )
    contact_mechanism_module.save!

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Contact Mechanisms',
        title: 'Contact Mechanisms',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {}

    contact_mechanism_module.dynamic_ui_components << organizer_view
    contact_mechanism_module.save!

    # setup web view
    web_view = WebView.new(
        description: 'Contact Mechanisms',
        title: 'Contact Mechanisms',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    contact_mechanism_module.dynamic_ui_components << web_view
    contact_mechanism_module.save!

    # setup mobile view
    mobile_view = MobileView.new(
        description: 'Contact Mechanisms',
        title: 'Contact Mechanisms',
        icon_src: '/assets/erp_app/icons/business_party_64x64.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    mobile_view.meta_data = {}

    contact_mechanism_module.dynamic_ui_components << mobile_view
    contact_mechanism_module.save!

    # setup list view fields
    [
        ['Description', 'description', 'text'],
        ['Contact Information', 'contact_information', 'text'],
        ['Contact Purposes', 'contact_purposes', 'text']
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
      organizer_view.add_available_field(field_definition, :list)
      web_view.add_available_field(field_definition.dup, :list)
      mobile_view.add_available_field(field_definition.dup, :list)
    end

    [organizer_view, web_view].each do |view|
      %w{contact_information contact_purposes}.each do |field_name|
        list_view_field = view.available_list_view_fields.where('field_name = ?', field_name).first
        list_view_field.added_to_view = true
        list_view_field.save
      end
    end

    mobile_list_view = FieldSet.new(
        {
            field_set_name: 'mobile_list_view',
            label: 'Mobile List View',
            columns: 1
        }
    )

    mobile_view.field_sets << mobile_list_view
    mobile_view.save

    %w{contact_information contact_purposes}.each do |field_name|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_name).first, 1)
      mobile_list_view.save
    end

    # setup Phone Number Sub Module
    self.create_sub_module('Phone Number', 'phone_number', 'PhoneNumber', [
                                             ['Description', 'description', 'text'],
                                             ['Phone Number', 'phone_number', 'phone_number'],
                                             ['Contact Purposes', 'contact_purposes', 'contact_purpose']
                                         ], %w{contact_purposes phone_number}, contact_mechanism_module)

    # setup Email Address Sub Module
    self.create_sub_module('Email Address', 'email_address', 'EmailAddress', [
                                             ['Description', 'description', 'text'],
                                             ['Email Address', 'email_address', 'email'],
                                             ['Contact Purposes', 'contact_purposes', 'contact_purpose']
                                         ], %w{contact_purposes email_address}, contact_mechanism_module)

    # setup Postal Address Sub Module
    self.create_sub_module('Postal Address', 'postal_address', 'PostalAddress', [
                                              ['Description', 'description', 'text'],
                                              ['Postal Address', 'postal_address', 'address'],
                                              ['Contact Purposes', 'contact_purposes', 'contact_purpose']
                                          ], %w{contact_purposes postal_address}, contact_mechanism_module)

  end

  def self.down
    BusinessModule.iid('contact_mechanism').destroy
  end

  #
  # Helper Methods
  #

  def self.create_sub_module(description, internal_identifier, root_model, field_data, field_iids, contact_mechanism_module)
    sub_module = BusinessModule.create(
        description: description,
        internal_identifier: internal_identifier,
        data_manager_name: 'ContactMechanism',
        root_model: root_model,
        can_create: false,
        can_associate: false
    )
    sub_module.save!
    sub_module.move_to_child_of(contact_mechanism_module)

    organizer_view = OrganizerView.new(
        description: description,
        title: description,
        can_edit_list_view: false
    )
    sub_module.dynamic_ui_components << organizer_view

    # setup Individual Web View
    web_view = WebView.new(
        description: description,
        title: description,
        can_edit_list_view: false
    )
    sub_module.dynamic_ui_components << web_view

    # setup Individual Mobile View
    mobile_view = MobileView.new(
        description: description,
        title: description,
        can_edit_list_view: false
    )
    sub_module.dynamic_ui_components << mobile_view

    # setup fields
    field_data.each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type)
                                             })

      field_definition.save

      organizer_view.add_available_field(field_definition, :detail)

      web_view.add_available_field(field_definition.dup, :detail)

      mobile_view.add_available_field(field_definition.dup, :detail)
    end

    [organizer_view, web_view].each do |view|
      details_field_set = FieldSet.new(
          {
              field_set_name: 'details',
              label: 'Details',
              columns: 1
          }
      )

      field_iids.each do |field_iid|
        details_field_set.add_field(view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      end

      details_field_set.save
      view.field_sets << details_field_set

      view.save
    end

    mobile_detail_view = FieldSet.new(
        {
            field_set_name: 'mobile_detail_view',
            label: 'Details',
            columns: 1
        }
    )

    mobile_view.field_sets << mobile_detail_view
    mobile_view.save

    field_iids.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end
  end

end
