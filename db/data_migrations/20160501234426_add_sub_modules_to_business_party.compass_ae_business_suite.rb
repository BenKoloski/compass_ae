# This migration comes from compass_ae_business_suite (originally 20150426125357)
class AddSubModulesToBusinessParty

  def self.up
    individual_sub_module = nil
    organization_sub_module = nil

    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'business_party', 'business_party').each do |biz_module|

      # get party type
      party_type = biz_module.meta_data['party_type']

      # update views so you can not edit detail view
      biz_module.organizer_view.can_edit_detail_view = false
      biz_module.organizer_view.save

      # update views so you can not edit detail view
      biz_module.web_view.can_edit_detail_view = false
      biz_module.web_view.save

      # update views so you can not edit detail view
      biz_module.mobile_view.can_edit_detail_view = false
      biz_module.mobile_view.save

      # create sub modules
      # setup Individual Sub Module
      individual_sub_module = BusinessModule.create(
          description: 'Individual',
          internal_identifier: 'individual',
          data_manager_name: 'BusinessParty',
          parent_module_type: 'business_party',
          root_model: 'Individual',
          can_create: false,
          can_associate: false
      )
      individual_sub_module.save!
      individual_sub_module.move_to_child_of(biz_module)

      # add views
      # setup Individual Organizer View
      organizer_view = OrganizerView.new(
          description: 'Individual Organizer View',
          title: 'Individual',
          can_edit_list_view: false
      )
      individual_sub_module.dynamic_ui_components << organizer_view

      # setup Individual Web View
      web_view = WebView.new(
          description: 'Individual Web View',
          title: 'Individual',
          can_edit_list_view: false
      )
      individual_sub_module.dynamic_ui_components << web_view

      # setup Individual Mobile View
      mobile_view = MobileView.new(
          description: 'Individual Mobile View',
          title: 'Individual',
          can_edit_list_view: false
      )
      individual_sub_module.dynamic_ui_components << mobile_view

      # if party type is organization then setup the Individual views
      if party_type == 'Organization'
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
            ['Total Years Work Experience', 'total_years_work_experience', 'number']
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
          web_view.add_available_field(field_definition.dup, :detail)
        end

        details_field_set = FieldSet.new(
            {
                field_set_name: 'name',
                label: 'Name',
                columns: 1
            }
        )

        %w{current_first_name current_middle_name current_last_name}.each do |field_iid|
          details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        end

        details_field_set.save
        organizer_view.field_sets << details_field_set

        organizer_view.save

        details_field_set = FieldSet.new(
            {
                field_set_name: 'name',
                label: 'Name',
                columns: 1
            }
        )

        %w{current_first_name current_middle_name current_last_name}.each do |field_iid|
          details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        end

        details_field_set.save
        web_view.field_sets << details_field_set

        # setup mobile view

        [
            ['First Name', 'current_first_name', 'text'],
            ['Last Name', 'current_last_name', 'text'],
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
        end

        mobile_detail_view = FieldSet.new(
            {
                field_set_name: 'mobile_detail_view',
                label: 'Individual',
                columns: 1
            }
        )

        mobile_view.field_sets << mobile_detail_view
        mobile_view.save

        %w{current_first_name current_last_name current_middle_name pictures}.each do |field_iid|
          mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
          mobile_detail_view.save
        end
        # if this an Individual party type module then copy over fields and field sets
      else
        # remove Tax ID field
        field = biz_module.organizer_view.selected_fields.where('field_name = ?', 'tax_id_number').first
        field.destroy if field

        field = biz_module.mobile_view.selected_fields.where('field_name = ?', 'tax_id_number').first
        field.destroy if field

        field = biz_module.web_view.selected_fields.where('field_name = ?', 'tax_id_number').first
        field.destroy if field

        self.update_fields(biz_module, organizer_view, web_view, mobile_view, :individual)
      end

      # setup Organization Sub Module
      organization_sub_module = BusinessModule.create(
          description: 'Organization',
          internal_identifier: 'organization',
          data_manager_name: 'BusinessParty',
          parent_module_type: 'business_party',
          root_model: 'Organization',
          can_create: false,
          can_associate: false
      )
      organization_sub_module.save!
      organization_sub_module.move_to_child_of(biz_module)

      # add views
      # setup Organization Organizer View
      organizer_view = OrganizerView.new(
          description: 'Organization Organizer View',
          title: 'Organization',
          can_edit_list_view: false
      )
      organization_sub_module.dynamic_ui_components << organizer_view

      # setup Organization Web View
      web_view = WebView.new(
          description: 'Organization Web View',
          title: 'Organization',
          can_edit_list_view: false
      )
      organization_sub_module.dynamic_ui_components << web_view

      # setup Organization Mobile View
      mobile_view = MobileView.new(
          description: 'Organization Mobile View',
          title: 'Organization',
          can_edit_list_view: false
      )
      organization_sub_module.dynamic_ui_components << mobile_view

      # if party type is Individual then setup the Organization views
      if party_type == 'Individual'
        [
            ['Description', 'description', 'text'],
            ['Tax ID', 'tax_id_number', 'text'],
            ['Pictures', 'pictures', 'pictures']
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

          if field_name == 'pictures'
            mobile_view.add_available_field(field_definition.dup, :detail)
          else
            organizer_view.add_available_field(field_definition, :detail)
            web_view.add_available_field(field_definition.dup, :detail)
            mobile_view.add_available_field(field_definition.dup, :detail)
          end
        end

        details_field_set = FieldSet.new(
            {
                field_set_name: 'details',
                label: 'Details',
                columns: 1
            }
        )

        %w{description tax_id_number}.each do |field_iid|
          details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        end

        organizer_view.field_sets << details_field_set
        organizer_view.save

        details_field_set = FieldSet.new(
            {
                field_set_name: 'details',
                label: 'Details',
                columns: 1
            }
        )

        %w{description tax_id_number}.each do |field_iid|
          details_field_set.add_field(web_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        end

        web_view.field_sets << details_field_set
        web_view.save

        mobile_detail_view_field_set = FieldSet.new(
            {
                field_set_name: 'mobile_detail_view',
                label: 'Organization',
                columns: 1
            }
        )

        %w{description tax_id_number pictures}.each do |field_iid|
          mobile_detail_view_field_set.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        end

        mobile_view.field_sets << mobile_detail_view_field_set
        mobile_view.save
        # if this an Organization party type module then copy over fields and field sets
      else
        self.update_fields(biz_module, organizer_view, web_view, mobile_view, :organization)
      end

    end

    OrganizerView.all.each do |c|
      c.compile
    end
  end

  def self.down
    #remove data here
  end

  def self.update_fields(biz_module, organizer_view, web_view, mobile_view, type)
    #################################
    # organizer view
    #################################

    biz_module.organizer_view.all_detail_view_fields.each do |field_definition|
      # add field to new view
      # do not add description field if this is an Individual
      if type == :individual && field_definition.field_name == 'description'
        field_definition.destroy
      else
        organizer_view.add_field(field_definition, :detail)
        biz_module.organizer_view.remove_field(field_definition, :detail)
      end
    end

    # remove all fields from current view except list view description
    biz_module.organizer_view.component_member_fields.joins(:field_definition).where('field_name <> ? and view <> ?', 'description', 'list').destroy_all

    biz_module.organizer_view.field_sets.each do |field_set|
      # remove description field if this is individual and add first_name, last_name
      field_set.field_definitions.each do |field_definition|
        if type == :individual && field_definition.field_name == 'description'
          field_set.field_definitions.delete(field_definition)
        end
      end

      organizer_view.all_detail_view_fields.each do |field_definition|
        # lock description, first name, last name
        if %w{current_first_name current_last_name description}.include? field_definition.field_name
          field_definition.locked = true
          field_definition.save
        end

        if type == :individual && (field_definition.field_name == 'current_first_name' or field_definition.field_name == 'current_last_name')
          unless field_set.field_definitions.where('id' => field_definition.id).first
            field_set.add_field(field_definition, 1)
          end
        end
      end

      field_set.update_attribute('dynamic_ui_component_id', organizer_view.id)
      field_set.save
    end

    #################################
    # web view
    #################################

    biz_module.web_view.all_detail_view_fields.each do |field_definition|
      # do not add description field if this is an Individual
      if type == :individual && field_definition.field_name == 'description'
        field_definition.destroy
      else
        web_view.add_field(field_definition, :detail)
        biz_module.web_view.remove_field(field_definition, :detail)
      end
    end

    # remove all fields from current view except list view description
    biz_module.web_view.component_member_fields.joins(:field_definition).where('field_name <> ? and view <> ?', 'description', 'list').destroy_all

    biz_module.web_view.field_sets.each do |field_set|
      # remove description field if this is individual and add first_name, last_name
      field_set.field_definitions.each do |field_definition|
        if type == :individual && field_definition.field_name == 'description'
          field_set.field_definitions.delete(field_definition)
        end
      end

      web_view.all_detail_view_fields.each do |field_definition|
        # lock description, first name, last name
        if %w{current_first_name current_last_name description}.include? field_definition.field_name
          field_definition.locked = true
          field_definition.save
        end

        if type == :individual && (field_definition.field_name == 'current_first_name' or field_definition.field_name == 'current_last_name')
          unless field_set.field_definitions.where('id' => field_definition.id).first
            field_set.add_field(field_definition, 1)
          end
        end
      end

      field_set.update_attribute('dynamic_ui_component_id', web_view.id)
      field_set.save
    end

    #################################
    # mobile view
    #################################

    biz_module.mobile_view.all_detail_view_fields.each do |field_definition|
      # do not add description field if this is an Individual
      if type == :individual && field_definition.field_name == 'description'
        field_definition.destroy
      else
        mobile_view.add_field(field_definition, :detail)
        biz_module.mobile_view.remove_field(field_definition, :detail)
      end
    end

    # remove all fields from current view except list view description
    biz_module.mobile_view.component_member_fields.joins(:field_definition).where('field_name <> ? and view <> ?', 'description', 'list').destroy_all

    # remove all fields from mobile list view except description
    biz_module.mobile_view.all_list_view_fields.each do |field_definition|
      field_definition.destroy unless field_definition.field_name == 'description'
    end

    # move all field sets to sub module detail view unless its a the mobile list view field set
    biz_module.mobile_view.field_sets.each do |field_set|
      if field_set.field_set_name == 'mobile_list_view'
        # remove all fields except description from list view
        field_set.field_definitions.each do |field_definition|
          field_set.field_definitions.delete(field_definition) unless field_definition.field_name == 'description'
        end
      end

      if field_set.field_set_name == 'mobile_detail_view'
        # remove description field if this is individual
        field_set.field_definitions.each do |field_definition|
          # lock description, first name, last name
          if %w{current_first_name current_last_name description}.include? field_definition.field_name
            field_definition.locked = true
            field_definition.save
          end

          if type == :individual && field_definition.field_name == 'description'
            field_set.field_definitions.delete(field_definition)
          end
        end

        field_set.update_attribute('dynamic_ui_component_id', mobile_view.id)
        field_set.save!
      end
    end
  end

end
