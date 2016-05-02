# This migration comes from compass_ae_business_suite (originally 20151115161117)
class RemoveWorkEffortTypeFieldType

  def self.up
    FieldDefinition.joins(:field_type).where({field_types: {internal_identifier: 'work_effort_type_field'}}).all.each do |field|
      field.destroy
    end

    FieldType.iid('work_effort_type_field').destroy
  end

  def self.down
    # NO DOWN SO BE CAREFUL
  end

end
