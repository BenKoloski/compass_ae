# This migration comes from compass_ae_business_suite (originally 20140523120840)
class SetUpBizTxnEventsModule
  def self.up

    transactions_module = BusinessModule.create(
        description: 'Transactions',
        internal_identifier: 'transactions',
        data_manager_name: 'Transactions',
        root_model: 'BizTxnEvent',
        can_associate: true,
        can_create: true,
        is_template: true
    )

    organizer_view = OrganizerView.new(
        description: 'Transactions Template',
        title: 'Transactions Template',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png'
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }

    organizer_view.save
    transactions_module.dynamic_ui_components << organizer_view
    transactions_module.save

    web_view = WebView.new(
        description: 'Transactions Template',
        title: 'Transactions Template'
    )


    web_view.save
    transactions_module.dynamic_ui_components << web_view
    transactions_module.save

    mobile_view = MobileView.new(
        description: 'Transaction Template',
        title: 'Mobile View Template',
        icon_src: '/assets/erp_app/icons/business_party_64x64.png'
    )

    mobile_view.save
    transactions_module.dynamic_ui_components << mobile_view
    transactions_module.save

    [
        ['Description', 'description', 'text'],
        ['Comments', 'comments', 'text_area'],
        ['Entered Date', 'entered_date', 'date'],
        ['Post Date', 'post_date', 'date']
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

      organizer_view.add_available_field(field_definition, 'detail')
      organizer_view.add_available_field(field_definition.dup, 'list')
      web_view.add_available_field(field_definition.dup, 'detail')
      web_view.add_available_field(field_definition.dup, 'list')
      mobile_view.add_available_field(field_definition.dup, 'detail')
      mobile_view.add_available_field(field_definition.dup, 'list')
    end

    organizer_details_field_set = FieldSet.new(
        {
            field_set_name: 'details',
            label: 'Details',
            columns: 1
        }
    )
    organizer_view.field_sets << organizer_details_field_set
    organizer_view.save

    web_details_field_set = FieldSet.new(
        {
            field_set_name: 'details',
            label: 'Details',
            columns: 1
        }
    )
    web_view.field_sets << web_details_field_set
    web_view.save

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

    # add fields to field set
    %w{description comments entered_date}.each do |field_iid|
      field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      field = web_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save

      organizer_details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      organizer_details_field_set.save

      web_details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      web_details_field_set.save

      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

  end

  def self.down
    #remove data here
  end

end