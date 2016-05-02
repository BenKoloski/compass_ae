# This migration comes from compass_ae_business_suite (originally 20140518150203)
class AddActivityStreamModule
  
  def self.up
    # create activity stream module's template
    activity_stream_module = BusinessModule.create(
        description: 'Activity Stream',
        internal_identifier: 'activity_stream',
        data_manager_name: 'ActivityStream',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    organizer_view = OrganizerView.new(
        description: 'Activity Stream',
        can_edit_detail_view: false,
        can_edit_list_view: false,
        title: 'Activity Stream',
        icon_src: '/assets/erp_app/shared/activity_stream_64x64.png'
    )

    organizer_view.meta_data = {
        ext_js:{
            xtype: 'activitystream'
        }
    }
    activity_stream_module.dynamic_ui_components << organizer_view

    web_view = WebView.new(
        description: 'Activity Stream',
        can_edit_detail_view: false,
        can_edit_list_view: false,
        title: 'Activity Stream'
    )

    activity_stream_module.dynamic_ui_components << web_view

    activity_stream_module.save

  end
  
  def self.down
    #remove data here
  end

end
