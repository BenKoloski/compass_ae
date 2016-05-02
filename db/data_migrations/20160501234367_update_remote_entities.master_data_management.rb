# This migration comes from master_data_management (originally 20150410194635)
class UpdateRemoteEntities

  def self.up
    quickbooks = ExternalSystem.iid('quickbooks')
    quickbooks.custom_data['remote_entities'] = ['customer', 'vendor', 'product_type', 'invoice', 'payment']
    quickbooks.save!
  end

  def self.down
    quickbooks = ExternalSystem.iid('quickbooks')
    quickbooks.custom_data['remote_entities'] = []
    quickbooks.save!
  end

end
