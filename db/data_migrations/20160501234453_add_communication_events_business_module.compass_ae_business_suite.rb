# This migration comes from compass_ae_business_suite (originally 20160120082523)
class AddCommunicationEventsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
      description: 'Communication Event',
      internal_identifier: 'communication_events',
      data_manager_name: 'CommunicationEvents',
      root_model: 'CommunicationEvent',
      can_create: true,
      can_associate: true,
      is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
      description: 'Communication Event',
      title: 'CommunicationEvents',
      icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
      can_edit_detail_view: false,
      can_edit_list_view: false
    )

    organizer_view.meta_data = {
      ext_js:{
        xtype: 'communicationeventslistview'
      }
    }

    new_module.dynamic_ui_components << organizer_view


    # add fields: field type should exist in FieldType or you'll get nil. Bad things will happen at run time
    [
      ['From', 'from_party', 'text'],
      ['To', 'to_party', 'text'],
      ['Subject', 'subject', 'text'],
      ['Type', 'event_type', 'text'],
      ['Start', 'start_at', 'datetime'],
      ['End', 'end_at', 'datetime'],
      ['Status', 'status', 'status'],
      ['Owner', 'event_owner', 'text'],
      ['Notes', 'notes', 'text_area']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                               field_name: field_name,
                                               label: label,
                                               locked: true,
                                               field_type: FieldType.iid(field_type)
      })

      field_definition.save

      # add to other views
      organizer_view.add_available_field(field_definition, :detail)
      organizer_view.add_available_field(field_definition.dup, :list)

    end

    details_field_set = FieldSet.new({
                                       field_set_name: 'details',
                                       label: 'Details',
                                       columns: 2
    })

    # add fields to field set
    %w{from_party to_party subject event_type start_at end_at status}.each do |field_iid|
      field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      field.added_to_view = true
      field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    %w{notes}.each do |field_iid|
      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 2)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

    # setup mobile view

    mobile_view = MobileView.new(
      description: 'Communication Event',
      title: 'Communication Event',
      icon_src: '',
      can_edit_detail_view: false,
      can_edit_list_view: false
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

    [
      ['From', 'from_party', 'text'],
      ['To', 'to_party', 'text'],
      ['Subject', 'subject', 'text'],
      ['Type', 'event_type', 'text'],
      ['Start', 'start_at', 'datetime'],
      ['End', 'end_at', 'datetime'],
      ['Status', 'status', 'status'],
      ['Notes', 'notes', 'text_area']
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]

      field_definition = FieldDefinition.new({
                                               field_name: field_name,
                                               label: label,
                                               locked: true,
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

    %w{from_party to_party subject event_type start_at end_at status notes}.each do |field_iid|
      mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_detail_view.save
    end

    %w{subject}.each do |field_iid|
      mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
      mobile_list_view.save
    end
  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'communication_events', 'communication_events').destroy_all
  end
end
