# This migration comes from compass_ae_business_suite (originally 20151009060404)
class AddReportsBusinessModule

  def self.up
    reports_module = BusinessModule.create(
        description: 'Reports',
        internal_identifier: 'reports',
        data_manager_name: 'Reports',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    organizer_view = OrganizerView.new(
        description: 'Reports',
        can_edit_detail_view: false,
        can_edit_list_view: false,
        title: 'Reports',
        icon_src: '/assets/erp_app/shared/reports_64x64.png'
    )

    organizer_view.meta_data = {
        ext_js: {
        }
    }
    reports_module.dynamic_ui_components << organizer_view

    web_view = WebView.new(
        description: 'Reports',
        can_edit_detail_view: false,
        can_edit_list_view: false,
        title: 'Reports'
    )

    reports_module.dynamic_ui_components << web_view

    reports_module.save

  end

  def self.down
  end

end
