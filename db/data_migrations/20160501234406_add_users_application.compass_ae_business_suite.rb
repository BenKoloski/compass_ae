# This migration comes from compass_ae_business_suite (originally 20150213202521)
class AddUsersApplication

  def self.up
    app = Application.create(
        :description => 'Users',
        :icon => 'icon-user',
        :internal_identifier => 'users',
        :can_delete => false,
        :allow_business_modules => false
    )

    admin_user = User.find_by_username('admin')
    if admin_user
      admin_user.applications << app
      admin_user.save
    end
  end

  def self.down
    Application.iid('users').destroy
  end

end
