# This migration comes from compass_ae_business_suite (originally 20150711235404)
class AddWorkEffortFieldTypes

  def self.up
    # WorkEffort Type
    field_type = FieldType.create({
                                      description: 'Work Effort Type',
                                      internal_identifier: 'work_effort_type_field'
                                  })

    field_type.meta_data = {ext_js: {xtype: 'businessmoduleworkefforttypefield'}}
    field_type.save
    field_type.move_to_child_of(FieldType.iid('advanced_field_types'))

    # Effort
    field_type = FieldType.create({
                                      description: 'Effort',
                                      internal_identifier: 'effort'
                                  })
    field_type.meta_data = {ext_js: {xtype: 'effortfield'}}
    field_type.save
    field_type.move_to_child_of(FieldType.iid('advanced_field_types'))

    # Duration
    field_type = FieldType.create({
                                      description: 'Duration',
                                      internal_identifier: 'duration'
                                  })
    field_type.meta_data = {ext_js: {xtype: 'durationfield'}}
    field_type.save
    field_type.move_to_child_of(FieldType.iid('advanced_field_types'))

    # Percent
    field_type = FieldType.create({
                                      description: 'Percent',
                                      internal_identifier: 'percent'
                                  })
    field_type.meta_data = {ext_js: {xtype: 'percentfield'}}
    field_type.save
    field_type.move_to_child_of(FieldType.iid('advanced_field_types'))
  end

  def self.down
    FieldType.find_by_internal_identifier('work_effort_type_field').destroy
    FieldType.find_by_internal_identifier('effort').destroy
    FieldType.find_by_internal_identifier('duration').destroy
    FieldType.find_by_internal_identifier('percent').destroy
  end

end
