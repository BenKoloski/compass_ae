# This migration comes from compass_ae_business_suite (originally 20151025135018)
class CleanUpCanCreateModules
  
  def self.up
    %w{party_skill positions files candidate_submissions staffing_requisitions experiences notes}.each do |module_iid|
      business_module = BusinessModule.templates.where('internal_identifier = ?', module_iid).first
      business_module.can_create = false
      business_module.save!
    end

    %w{position_fulfillment}.each do |module_iid|
      business_module = BusinessModule.templates.where('internal_identifier = ?', module_iid).first
      business_module.can_create = true
      business_module.save!
    end
  end
  
  def self.down
    %w{party_skill positions files candidate_submissions staffing_requisitions experiences notes}.each do |module_iid|
      business_module = BusinessModule.templates.where('internal_identifier = ?', module_iid).first
      business_module.can_create = true
      business_module.save!
    end

    %w{position_fulfillment}.each do |module_iid|
      business_module = BusinessModule.templates.where('internal_identifier = ?', module_iid).first
      business_module.can_create = false
      business_module.save!
    end
  end

end
