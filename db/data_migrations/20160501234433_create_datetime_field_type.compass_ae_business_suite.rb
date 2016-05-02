# This migration comes from compass_ae_business_suite (originally 20150711235603)
class CreateDatetimeFieldType

  def self.up
    unless FieldType.iid('datetime')
      field_type = FieldType.create({
                                        description: 'Date / Time',
                                        internal_identifier: 'datetime'
                                    })

      # set the custom xtype for the new field type
      field_type.meta_data = {ext_js: {xtype: 'datetimefield'}}
      field_type.save

      advanced_field_type = FieldType.iid('advanced_field_types')
      field_type.move_to_child_of(advanced_field_type)
    end

    # add date time field to Tasks modules
    BusinessModule.where('parent_module_type = ? or internal_identifier = ?', 'tasks', 'tasks').each do |business_module|
      if business_module.mobile_view
        business_module.mobile_view.field_definitions.where('field_type_id = ?', FieldType.iid('date').id).each do |f|
          f.field_type = FieldType.iid('datetime'); f.save;
        end
      end
    end
  end

  def self.down
    if FieldType.iid('datetime')
      FieldType.find_by_internal_identifier('datetime').destroy
    end

  end

end
