# This migration comes from master_data_management (originally 20150217195817)
class AddRemoteEntitiesToQuickbookExternalSystem
  
  def self.up
    quickbooks = ExternalSystem.iid('quickbooks')
    quickbooks.custom_data['remote_entities'] = ['customer', 'vendor', 'product_type', 'invoice']
    quickbooks.save!
  end
  
  def self.down
    quickbooks = ExternalSystem.iid('quickbooks')
    quickbooks.custom_data['remote_entities'] = []
    quickbooks.save!
  end

end
