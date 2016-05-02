# This migration comes from compass_ae_business_suite (originally 20160313150009)
class AddAuditLogBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Audit Log',
        internal_identifier: 'audit_log',
        data_manager_name: 'AuditLog',
        root_model: 'AuditLog',
        can_create: true,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Audit Log',
        title: 'Audit Log',
        icon_src: '/assets/erp_app/business_modules/audit_log/organizer.png',
        can_edit_detail_view: false,
        can_edit_list_view: false
    )

    organizer_view.meta_data = {
        ext_js: {
            xtype: 'auditloglistview'
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    #
    # Setup mobile view
    #

    mobile_view = MobileView.new(
        description: 'Audit Log',
        title: 'Audit Log',
        icon_src: '/assets/erp_app/business_modules/audit_log/mobile.png',
        can_edit_detail_view: false,
        can_edit_list_view: false
    )
    mobile_view.save

    new_module.dynamic_ui_components << mobile_view

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'audit_log', 'audit_log').destroy_all
  end
end
