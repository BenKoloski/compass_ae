# This migration comes from compass_ae_business_suite (originally 20150719082505)
class AddPartyRolesFieldType

  def self.up
    field_type = FieldType.create({
                                      description: 'Party Roles',
                                      internal_identifier: 'party_roles'
                                  })

    # set the custom xtype for the new field type
    field_type.meta_data = {ext_js: {xtype: 'businessmodulepartyrolesfield'}}
    field_type.save

    field_type.move_to_child_of(FieldType.iid('advanced_field_types'))
  end

  def self.down
    FieldType.find_by_internal_identifier('party_roles').destroy
  end

end
