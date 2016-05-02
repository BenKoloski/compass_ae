# This migration comes from compass_ae_business_suite (originally 20151211135813)
class AddExpensesBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Expenses',
        internal_identifier: 'expenses',
        data_manager_name: 'Expenses',
        root_model: 'FinancialTxn',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Expenses',
        title: 'Expenses',
        icon_src: '/assets/erp_app/business_modules/expenses/expenses.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js:{
            xtype: 'expenseslistview'
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Expenses',
        title: 'Expenses',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    expense_statuses = TrackedStatusType.find_or_create('expense_statuses', 'Expense Statuses')
    TrackedStatusType.find_or_create('expense_statuses_pending', 'Pending').move_to_child_of(expense_statuses)
    TrackedStatusType.find_or_create('expense_statuses_approved', 'Approved').move_to_child_of(expense_statuses)
    TrackedStatusType.find_or_create('expense_statuses_denied', 'Denied').move_to_child_of(expense_statuses)
    TrackedStatusType.find_or_create('expense_statuses_invoiced', 'Invoiced').move_to_child_of(expense_statuses)

    # add fields
    [
        ['Description', 'description', 'text', {}],
        ['Date ', 'apply_date', 'date', {}],
        ['Amount', 'amount', 'money', {}],
        ['Billable', 'billable', 'yes_no', {default_value: 'no'}],
        ['Status', 'status', 'status',  {parent_tracked_status_type_iid: 'expense_statuses', ext_js: {parentTrackedStatusTypeIid: 'expense_statuses'}}],
        ['Pictures', 'pictures', 'file_assets', {}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.meta_data = meta_data

      field_definition.save!

      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)
      web_view.add_available_field(field_definition.dup, :detail)
      web_view.add_available_field(field_definition.dup, :list)
    end

    #
    # Setup Organizer View Detail View Field Sets and List View
    #

    details_field_set = FieldSet.new({
                                         field_set_name: 'details',
                                         label: 'Details',
                                         columns: 2
                                     })

    # add fields to field set
    %w{description apply_date amount billable status}.each do |field_iid|
      description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    # add fields to field set
    %w{pictures}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
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
                                         columns: 2
                                     })

    # add fields to field set
    %w{description apply_date billable amount}.each do |field_iid|
      description_list_view_field = web_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    # add fields to field set
    %w{pictures}.each do |field_iid|
      details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      details_field_set.save
    end

    web_view.field_sets << details_field_set
    web_view.save

    #
    # Setup Mobile View
    #

    mobile_view = MobileView.new(
        description: 'Expenses',
        title: 'Expenses',
        icon_src: '/assets/icons/default_mobile_app.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
        ['Description', 'description', 'text', {}],
        ['Date ', 'apply_date', 'date', {}],
        ['Amount', 'amount', 'money', {}],
        ['Billable', 'billable', 'yes_no', {default_value: 'no'}],
        ['Status', 'status', 'status',  {parent_tracked_status_type_iid: 'expense_statuses', ext_js: {parentTrackedStatusTypeIid: 'expense_statuses'}}],
        ['Pictures', 'pictures', 'pictures', {}]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      meta_data = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                             })

      field_definition.meta_data = meta_data

      field_definition.save!

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

    %w{description apply_date amount billable status pictures}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

    %w{description apply_date amount status}.each do |field_iid|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end

    notes_associator = CompassAeBusinessSuite::BusinessModules::Associator::Notes.new(new_module, {name: 'Comments', note_type_ids: 'Comment'}, nil)
    notes_module = notes_associator.create_and_associate
    notes_module.save!

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'expenses', 'expenses').destroy_all
  end
end
