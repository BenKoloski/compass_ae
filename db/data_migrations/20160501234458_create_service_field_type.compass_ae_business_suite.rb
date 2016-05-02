# This migration comes from compass_ae_business_suite (originally 20160415201652)
class CreateServiceFieldType
  
  def self.up
    field_type = FieldType.create({
        description: 'Service',
        internal_identifier: 'service'
    })

    # set the custom xtype for the new field type
    field_type.meta_data = {ext_js: {xtype: 'businessmoduleservicefield'}}
    field_type.save

    # move under advanced category
    # TODO: update to pass in a custom category and move the created field type under it
    advanced_field_type = FieldType.iid('advanced_field_types')
    field_type.move_to_child_of(advanced_field_type)
  end

  def self.down
    FieldType.find_by_internal_identifier('service').destroy
  end
end
