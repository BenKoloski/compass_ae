# This migration comes from compass_ae_business_suite (originally 20150306023955)
class CreateUserInformationFieldType
  
  def self.up
    field_type = FieldType.create({
        description: 'User Information',
        internal_identifier: 'user_information'
    })

    # set the custom xtype for the new field type
    field_type.meta_data = {ext_js: {xtype: 'businessmoduleuserinformationfield'}}
    field_type.save

    # move under advanced category
    # TODO: update to pass in a custom category and move the created field type under it
    advanced = FieldType.iid('advanced_field_types')
    field_type.move_to_child_of(advanced)
  end

  def self.down
    FieldType.find_by_internal_identifier('user_information').destroy
  end
end
