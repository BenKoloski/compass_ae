# This migration comes from compass_ae_business_suite (originally 20150807011530)
class AddGeoTrackerBusinessModule

  def self.up

    geo_tracker_module = BusinessModule.create(
        description: 'Geo Tracker',
        internal_identifier: 'geo_tracker',
        data_manager_name: 'GeoTracker',
        can_create: true,
        can_associate: false,
        is_template: true
    )

    organizer_view = OrganizerView.new(
        description: 'Geo Tracker',
        can_edit_detail_view: false,
        can_edit_list_view: false,
        title: 'Geo Tracker',
        icon_src: '/assets/erp_app/business_modules/geo_tracker/geo_tracker.png'
    )

    organizer_view.meta_data = {
        ext_js:{
            xtype: 'geotracker'
        }
    }
    geo_tracker_module.dynamic_ui_components << organizer_view

    web_view = WebView.new(
        description: 'Geo Tracker',
        can_edit_detail_view: false,
        can_edit_list_view: false,
        title: 'Geo Tracker'
    )

    geo_tracker_module.dynamic_ui_components << web_view

    geo_tracker_module.save

  end

  def self.down
    BusinessModule.where('internal_identifier = ?', 'geo_tracker').first.destroy
  end
end
