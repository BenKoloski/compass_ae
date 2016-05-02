# This migration comes from compass_ae_business_suite (originally 20140320082314)
class CreateFieldTypes

  def self.up
    basic_field_type = FieldType.create({
                                            description: 'Basic Field Types',
                                            internal_identifier: 'basic_field_types'
                                        })

    advanced_field_type = FieldType.create({
                                               description: 'Advanced Field Types',
                                               internal_identifier: 'advanced_field_types'
                                           })

    [
        {
            description: 'Text',
            xtype: 'textfield',
            category: :basic
        },
        {
            description: 'Text Area',
            xtype: 'textarea',
            category: :basic
        },
        {
            description: 'Number',
            xtype: 'numberfield',
            category: :basic
        },
        {
            description: 'Check',
            xtype: 'checkboxfield',
            category: :basic
        },
        {
            description: 'Select',
            xtype: 'combo',
            category: :basic
        },
        {
            description: 'Radio',
            xtype: 'radio',
            category: :basic
        },
        {
            description: 'Date',
            xtype: 'datefield',
            category: :basic
        },
        {
            description: 'Time',
            xtype: 'timefield',
            category: :basic
        },
        {
            description: 'Password',
            xtype: 'password',
            category: :basic
        },
        {
            description: 'Display',
            xtype: 'displayfield',
            category: :basic
        },
        {
            description: 'Email',
            xtype: 'email',
            category: :basic
        },
        {
            description: 'Image',
            xtype: 'image',
            category: :basic
        },
        {
            description: 'Yes / No',
            internal_identifier: 'yes_no',
            xtype: 'yesno',
            category: :basic
        },
        {
            description: 'Rich Text Area',
            xtype: 'businessmodulerichtextareafield',
            category: :basic
        },
        {
            description: 'File',
            xtype: 'filefield',
            category: :advanced
        },
        {
            description: 'Business Party',
            xtype: 'businessmodulebusinesspartyfield',
            category: :advanced
        },
        {
            description: 'File Assets',
            xtype: 'businessmodulefileassetsfield',
            category: :advanced
        },
        {
            description: 'Question',
            xtype: 'question',
            category: :advanced
        },
        {
            description: 'Money',
            xtype: 'moneyfield',
            category: :advanced
        },
        {
            description: 'Address',
            xtype: 'businessmoduleaddressfield',
            category: :advanced
        },
        {
            description: 'Category',
            xtype: 'businessmodulecategoryfield',
            category: :advanced
        },
        {
            description: 'Price',
            xtype: 'businessmodulepricefield',
            category: :advanced
        },
        {
            description: 'Tags',
            xtype: 'businessmoduletagsfield',
            category: :advanced
        },
        {
            description: 'Phone Number',
            xtype: 'businessmodulephonenumberfield',
            category: :advanced
        },
        {
            description: 'Status',
            xtype: 'businessmodulestatusfield',
            category: :advanced
        },
        {
            description: 'Product Type',
            xtype: 'businessmoduleproducttypefield',
            category: :advanced
        },
        {
            description: 'Relationship Type',
            xtype: 'businessmodulerelationshiptypefield',
            category: :advanced
        },
        {
            description: 'View Type',
            xtype: 'businessmoduleviewtypefield',
            category: :advanced
        },
        {
            description: 'Skill Type',
            xtype: 'businessmoduleskilltypefield',
            category: :advanced
        },
        {
            description: 'Position Type',
            xtype: 'businessmodulepositiontypefield',
            category: :advanced
        },
        {
            description: 'Role Type',
            xtype: 'businessmoduleroletypefield',
            category: :advanced
        },
        {
            description: 'HR Position',
            xtype: 'businessmodulehrpositionfield',
            category: :advanced
        },
        {
            description: 'Product Feature Type',
            xtype: 'businessmoduleproductfeaturetypefield',
            category: :advanced
        },
        {
            description: 'Product Feature Value',
            xtype: 'businessmoduleproductfeaturevaluefield',
            category: :advanced
        },
        {
            description: 'Pictures',
            category: :advanced
        },
        {
            description: 'Data Record',
            xtype: 'businessmoduledatarecordfield',
            category: :advanced
        }

    ].each do |type|
      field_type = FieldType.create({
                                     description: type[:description],
                                     internal_identifier: type[:internal_identifier] || type[:description].downcase.gsub(' ', '_').gsub('[^a-zA-Z|_]', '')
                                 })

      field_type.meta_data['ext_js'] = {xtype: type[:xtype]} if type[:xtype]
      field_type.save

      if type[:category] == :basic
        field_type.move_to_child_of(basic_field_type)
      else
        field_type.move_to_child_of(advanced_field_type)
      end
    end

  end

  def self.down
    FieldType.destroy_all
  end

end
