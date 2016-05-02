# This migration comes from master_data_management (originally 20150525074147)
class AddRchilliExternalSystems

  def self.up
    ExternalSystem.find_or_create('rchilli')
    admin_user = User.find_by_username('admin')
    if admin_user
      dba_organization = admin_user.party.dba_organization
    	ExternalSystem.find_by_internal_identifier('rchilli').add_party_with_role(dba_organization,
                                                                                   RoleType.find_or_create('owner', 'Owner'))
    end
  end

  def self.down
   ExternalSystem.iid('rchilli').destroy if ExternalSystem.iid('rchilli')
  end

end
