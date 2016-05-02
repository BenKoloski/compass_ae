# This migration comes from master_data_management (originally 20150114200352)
class AddStripeQuickbooksExternalSystems

  def self.up
    ExternalSystem.find_or_create('stripe')
    ExternalSystem.find_or_create('quickbooks')
  end

  def self.down
    ExternalSystem.iid('stripe').destroy if ExternalSystem.iid('stripe')
    ExternalSystem.iid('quickbooks').destroy if ExternalSystem.iid('quickbooks')
  end

end
