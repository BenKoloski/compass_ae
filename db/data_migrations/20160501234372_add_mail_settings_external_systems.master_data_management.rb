# This migration comes from master_data_management (originally 20160301064554)
class AddMailSettingsExternalSystems
  
  def self.up
    inbound_mail_settings = ExternalSystem.find_or_create('inbound_mail_settings')

    admin_user = User.find_by_username('admin')
    if admin_user
      dba_organization = admin_user.party.dba_organization
      inbound_mail_settings.add_party_with_role(
        dba_organization,
        RoleType.find_or_create('owner', 'Owner')
      )
    end

    outbound_mail_settings = ExternalSystem.find_or_create('outbound_mail_settings')

    admin_user = User.find_by_username('admin')
    if admin_user
      dba_organization = admin_user.party.dba_organization
      outbound_mail_settings.add_party_with_role(
          dba_organization,
          RoleType.find_or_create('owner', 'Owner')
      )
    end
  end
  
  def self.down
    ExternalSystem.iid('inbound_mail_settings').destroy if ExternalSystem.iid('inbound_mail_settings')
    ExternalSystem.iid('outbound_mail_settings').destroy if ExternalSystem.iid('outbound_mail_settings')
  end

end
