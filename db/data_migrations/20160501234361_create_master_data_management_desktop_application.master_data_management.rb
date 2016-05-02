# This migration comes from master_data_management (originally 20150114182417)
class CreateMasterDataManagementDesktopApplication
  def self.up
    app = DesktopApplication.create(
      :description => 'Integrations',
      :icon => 'icon-mdm',
      :internal_identifier => 'master_data_management'
    )

    app.save

    admin_user = User.find_by_username('admin')
    admin_user.desktop_applications << app
    admin_user.save
  end

  def self.down
    DesktopApplication.destroy_all(['internal_identifier = ?','master_data_management'])
  end
end
