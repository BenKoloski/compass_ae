# This migration comes from compass_ae_business_suite (originally 20140411141702)
class AddCrmRoleTypes
  
  def self.up
    crm = RoleType.create(description: 'CRM', internal_identifier: 'crm')

    customer = RoleType.iid('customer')
    customer.move_to_child_of(crm)
  end
  
  def self.down
    #remove data here
  end

end
