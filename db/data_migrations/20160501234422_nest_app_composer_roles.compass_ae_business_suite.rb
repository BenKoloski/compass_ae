# This migration comes from compass_ae_business_suite (originally 20150414151926)
class NestAppComposerRoles
  
  def self.up
    employee = SecurityRole.find_by_internal_identifier('employee')
    application_composer = SecurityRole.create(:internal_identifier => 'application_composer', :description => 'Application Composer')
    employee.move_to_child_of(application_composer)
  end
  
  def self.down
    employee = SecurityRole.find_by_internal_identifier('employee')
    employee.move_to_child_of(nil)
    SecurityRole.find_by_internal_identifier('application_composer').destroy
  end

end
