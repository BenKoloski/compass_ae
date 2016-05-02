# This migration comes from master_data_management (originally 20150618215437)
class AddPayPalExternalSystem

  def self.up
    external_system = ExternalSystem.find_or_create('pay_pal')

    # add Owner role type to root dba_org
    # look up admin user and get his dba_org
    admin_user = User.find_by_username('admin')
    if admin_user
      dba_organization = admin_user.party.dba_organization

      external_system.add_party_with_role(dba_organization,
                                          RoleType.find_or_create('owner', 'Owner'))

    end
  end

  def self.down
    ExternalSystem.iid('pay_pal').destroy if ExternalSystem.iid('pay_pal')
  end

end
