# This migration comes from compass_ae_business_suite (originally 20140528192937)
class AddCommEvtPurposeTypes
  
  def self.up
    CommEvtPurposeType.create(description: 'Inbound Call', internal_identifier: 'inbound_call')
    CommEvtPurposeType.create(description: 'Outbound Call', internal_identifier: 'outbound_call')
  end
  
  def self.down
    CommEvtPurposeType.find_by_internal_identifier('inbound_call').destroy
    CommEvtPurposeType.find_by_internal_identifier('outbound_call').destroy
  end

end
