# This migration comes from compass_ae_business_suite (originally 20150818074442)
class AddSignatureFieldType
  
  def self.up
    field_type = FieldType.create({
                                    description: 'Signature',
                                    internal_identifier: 'signature'
                                  })
    
    advanced_field_type = FieldType.iid('advanced_field_types')
    field_type.move_to_child_of(advanced_field_type)
  end
  
  def self.down
    FieldType.find_by_internal_identifier('signature').destroy
  end

end
