# This migration comes from compass_ae_business_suite (originally 20150306134850)
class CreateWcCodeFieldType

  def self.up
    # Want to add Wc Code as an 'advanced' field type. advanced_filed_types should exist
    # if compass is installed, but make sure , otherwise no sense in running this migration
    advanced_field_type = FieldType.where('internal_identifier = ?', 'advanced_field_types')

    unless advanced_field_type.nil?
      # create the wc code field type as a child of advanced_field_type
      field_type = FieldType.create({
                                        description: 'Wc Code',
                                        internal_identifier: 'wc_code'
                                    })
      field_type.meta_data['ext_js'] = {xtype: 'businessmodulewccodefield'}
      field_type.save
      field_type.move_to_child_of(advanced_field_type)
    end
  end

  def self.down
    wc_code_field_type = FieldType.where('internal_identifier = ?', 'wc_code')
    unless wc_code_field_type.nil?
      wc_code_field_type.destroy_all
    end
  end

end