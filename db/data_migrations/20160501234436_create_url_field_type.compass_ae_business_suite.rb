# This migration comes from compass_ae_business_suite (originally 20150715233419)
class CreateUrlFieldType
  
  def self.up
    field_type = FieldType.create({
        description: 'Url',
        internal_identifier: 'url'
    })

    # set the custom xtype for the new field type
    field_type.meta_data = {ext_js: {xtype: 'businessmoduleurlfield'}}
    field_type.save

    advanced_field_type = FieldType.iid('advanced_field_types')
    field_type.move_to_child_of(advanced_field_type)
  end

  def self.down
    FieldType.find_by_internal_identifier('url').destroy
  end
end
