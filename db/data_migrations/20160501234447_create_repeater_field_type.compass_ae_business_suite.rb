# This migration comes from compass_ae_business_suite (originally 20151016192334)
class CreateRepeaterFieldType
  
  def self.up
    field_type = FieldType.create({
        description: 'Repeater',
        internal_identifier: 'repeater'
    })

    # set the custom xtype for the new field type
    field_type.meta_data = {ext_js: {xtype: 'businessmodulerepeaterfield'}}
    field_type.save

    advanced_field_type = FieldType.iid('advanced_field_types')
    field_type.move_to_child_of(advanced_field_type)
  end

  def self.down
    FieldType.find_by_internal_identifier('repeater').destroy
  end
end
