# This migration comes from compass_ae_business_suite (originally 20150911152210)
class AddTimeEntriesBusinessModule

  def self.up

    # remove old time entry module
    if BusinessModule.find_by_internal_identifier('time_entries')
      BusinessModule.find_by_internal_identifier('time_entries').destroy
    end

    # create the module
    new_module = BusinessModule.create(
      description: 'Time Entries',
      internal_identifier: 'time_entries',
      data_manager_name: 'TimeEntries',
      root_model: 'TimeEntry',
      can_create: false,
      can_associate: true,
      is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
      description: 'Time Entries',
      title: 'Time Entries',
      icon_src: '/assets/erp_app/business_modules/time_entries/time_entries.png',
      can_edit_detail_view: false,
      can_edit_list_view: false
    )

    organizer_view.meta_data = {
      ext_js:{
        xtype: 'timeentrieslistview'
      }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup mobile view

    mobile_view = MobileView.new(
        description: 'Time Entries',
        title: 'Time Entries',
        icon_src: '/assets/icons/default_mobile_app.png',
        can_edit_detail_view: false,
        can_edit_list_view: false
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'time_entries', 'time_entries').destroy_all
  end
end
