# This migration comes from compass_ae_business_suite (originally 20141022051853)
class CreateUnitOfMeasurementFieldType
  
  def self.up
    field_type = FieldType.create({
        description: 'Unit',
        internal_identifier: 'unit_of_measurement'
    })
    
    # if there is a custom Ext JS xtype you can set it here
    field_type.meta_data = {ext_js: {xtype: 'uomcombofield'}}
    field_type.save
  end
  
  def self.down
  end

end
