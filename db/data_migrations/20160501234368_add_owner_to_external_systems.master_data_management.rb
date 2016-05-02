# This migration comes from master_data_management (originally 20150504162537)
class AddOwnerToExternalSystems

  def self.up
    # add Owner role type to root dba_org
    # look up admin user and get his dba_org
    admin_user = User.find_by_username('admin')
    if admin_user
      dba_organization = admin_user.party.dba_organization

      ExternalSystem.all.each do |external_system|
        external_system.add_party_with_role(dba_organization,
                                            RoleType.find_or_create('owner', 'Owner'))
      end
    end
  end

  def self.down
    #remove data here
  end

end
