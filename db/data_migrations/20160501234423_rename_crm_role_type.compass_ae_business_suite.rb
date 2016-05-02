# This migration comes from compass_ae_business_suite (originally 20150414173418)
class RenameCrmRoleType
  
  def self.up
    crm = RoleType.iid('crm')

    crm.description = 'Application Composer'
    crm.internal_identifier = 'application_composer'
    crm.save

    #
    # Move vendor under Application Composer
    #

    RoleType.iid('vendor').move_to_child_of(RoleType.iid('application_composer'))

    #
    # Move DBA Organization Role Type under Application Composer
    #

    RoleType.iid('dba_org').move_to_child_of(RoleType.iid('application_composer'))
  end
  
  def self.down
    crm = RoleType.iid('application_composer')

    crm.description = 'CRM'
    crm.internal_identifier = 'crm'
    crm.save
  end

end
