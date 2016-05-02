# This migration comes from master_data_management (originally 20150522183320)
class AddShippingExternalSystems

  def self.up
    ExternalSystem.find_or_create('fedex')
    ExternalSystem.find_or_create('ups')
    ExternalSystem.find_or_create('usps')

    ['fedex', 'ups', 'usps'].each do |system|
      # add Owner role type to root dba_org
      # look up admin user and get his dba_org
      admin_user = User.find_by_username('admin')
      if admin_user
        external_system = ExternalSystem.iid(system)
        if external_system
          dba_organization = admin_user.party.dba_organization
          external_system.add_party_with_role(dba_organization,
                                              RoleType.find_or_create('owner', 'Owner'))
        end
      end
    end
  end

  def self.down
    ExternalSystem.iid('fedex').destroy if ExternalSystem.iid('fedex')
    ExternalSystem.iid('ups').destroy if ExternalSystem.iid('ups')
    ExternalSystem.iid('usps').destroy if ExternalSystem.iid('usps')
  end

end
