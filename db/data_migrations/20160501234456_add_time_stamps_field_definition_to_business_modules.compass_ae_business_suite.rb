# This migration comes from compass_ae_business_suite (originally 20160205005051)
# This migration comes from compass_ae_business_suite (originally 20151125073016)
class AddTimeStampsFieldDefinitionToBusinessModules

  def self.up
    created_at_field_definition = FieldDefinition.create({
                                                field_name: 'created_at',
                                                label: 'Created',
                                                locked: false,
                                                field_type: FieldType.iid('display')
                                            })

    updated_at_field_definition = FieldDefinition.create({
                                                field_name: 'updated_at',
                                                label: 'Updated',
                                                locked: false,
                                                field_type: FieldType.iid('display')
                                            })

    BusinessModule.all.each do |business_module|
      if business_module.root_model.present?

        organizer_view = business_module.organizer_view
        web_view = business_module.web_view
        mobile_view = business_module.mobile_view

        # Add created_at and updated_at to organizer view
        if organizer_view.present?
          if organizer_view.all_list_view_fields.where(field_name: 'created_at').blank?
            organizer_view.add_available_field(created_at_field_definition.dup, :list)
          end
          if organizer_view.all_list_view_fields.where(field_name: 'updated_at').blank?
            organizer_view.add_available_field(updated_at_field_definition.dup, :list)
          end

          if organizer_view.all_detail_view_fields.where(field_name: 'created_at').blank?
            organizer_view.add_available_field(created_at_field_definition.dup, :detail)
          end
          if organizer_view.all_detail_view_fields.where(field_name: 'updated_at').blank?
            organizer_view.add_available_field(updated_at_field_definition.dup, :detail)
          end
        end

        # Add created_at and updated_at to web view
        if web_view.present?
          if web_view.all_list_view_fields.where(field_name: 'created_at').blank?
            web_view.add_available_field(created_at_field_definition.dup, :list)
          end
          if web_view.all_list_view_fields.where(field_name: 'updated_at').blank?
            web_view.add_available_field(updated_at_field_definition.dup, :list)
          end

          if web_view.all_detail_view_fields.where(field_name: 'created_at').blank?
            web_view.add_available_field(created_at_field_definition.dup, :detail)
          end

          if web_view.all_detail_view_fields.where(field_name: 'updated_at').blank?
            web_view.add_available_field(updated_at_field_definition.dup, :detail)
          end
        end

        # Add created_at and updated_at to mobile view
        if mobile_view.present?
          if mobile_view.all_list_view_fields.where(field_name: 'created_at').blank?
            mobile_view.add_available_field(created_at_field_definition.dup, :list)
          end
          if mobile_view.all_list_view_fields.where(field_name: 'updated_at').blank?
            mobile_view.add_available_field(updated_at_field_definition.dup, :list)
          end

          if mobile_view.all_detail_view_fields.where(field_name: 'created_at').blank?
            mobile_view.add_available_field(created_at_field_definition.dup, :detail)
          end

          if mobile_view.all_detail_view_fields.where(field_name: 'updated_at').blank?
            mobile_view.add_available_field(updated_at_field_definition.dup, :detail)
          end
        end

      end
    end # End loop

    [created_at_field_definition, updated_at_field_definition].each do |field|
      field.destroy
    end

  end # End self.up

  def self.down
    #remove data here
  end

end
