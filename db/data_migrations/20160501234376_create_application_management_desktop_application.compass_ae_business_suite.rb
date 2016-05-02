# This migration comes from compass_ae_business_suite (originally 20140324173454)
class CreateApplicationManagementDesktopApplication
  def self.up
    app = DesktopApplication.create(
      :description => 'Application Composer',
      :icon => 'icon-application_management',
      :internal_identifier => 'application_management'
    )

    admin_user = User.find_by_username('admin')
    admin_user.desktop_applications << app
    admin_user.save
  end

  def self.down
    DesktopApplication.destroy_all(['internal_identifier = ?','application_management'])
  end
end
