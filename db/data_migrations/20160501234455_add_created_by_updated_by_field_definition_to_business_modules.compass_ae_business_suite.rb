# This migration comes from compass_ae_business_suite (originally 20160205005050)
class AddCreatedByUpdatedByFieldDefinitionToBusinessModules

  def self.up
    created_by_field_definition = FieldDefinition.create({
                                                field_name: 'created_by',
                                                label: 'Created By',
                                                locked: false,
                                                field_type: FieldType.iid('display')
                                            })

    updated_by_field_definition = FieldDefinition.create({
                                                field_name: 'updated_by',
                                                label: 'Updated By',
                                                locked: false,
                                                field_type: FieldType.iid('display')
                                            })

    BusinessModule.all.each do |business_module|
      if business_module.root_model.present?

        organizer_view = business_module.organizer_view
        web_view = business_module.web_view
        mobile_view = business_module.mobile_view

        # Add created_by and updated_by to organizer view
        if organizer_view.present?
          if organizer_view.all_list_view_fields.where(field_name: 'created_by').blank?
            organizer_view.add_available_field(created_by_field_definition.dup, :list)
          end
          if organizer_view.all_list_view_fields.where(field_name: 'updated_by').blank?
            organizer_view.add_available_field(updated_by_field_definition.dup, :list)
          end

          if organizer_view.all_detail_view_fields.where(field_name: 'created_by').blank?
            organizer_view.add_available_field(created_by_field_definition.dup, :detail)
          end
          if organizer_view.all_detail_view_fields.where(field_name: 'updated_by').blank?
            organizer_view.add_available_field(updated_by_field_definition.dup, :detail)
          end
        end

        # Add created_by and updated_by to web view
        if web_view.present?
          if web_view.all_list_view_fields.where(field_name: 'created_by').blank?
            web_view.add_available_field(created_by_field_definition.dup, :list)
          end
          if web_view.all_list_view_fields.where(field_name: 'updated_by').blank?
            web_view.add_available_field(updated_by_field_definition.dup, :list)
          end

          if web_view.all_detail_view_fields.where(field_name: 'created_by').blank?
            web_view.add_available_field(created_by_field_definition.dup, :detail)
          end

          if web_view.all_detail_view_fields.where(field_name: 'updated_by').blank?
            web_view.add_available_field(updated_by_field_definition.dup, :detail)
          end
        end

        # Add created_by and updated_by to mobile view
        if mobile_view.present?
          if mobile_view.all_list_view_fields.where(field_name: 'created_by').blank?
            mobile_view.add_available_field(created_by_field_definition.dup, :list)
          end
          if mobile_view.all_list_view_fields.where(field_name: 'updated_by').blank?
            mobile_view.add_available_field(updated_by_field_definition.dup, :list)
          end

          if mobile_view.all_detail_view_fields.where(field_name: 'created_by').blank?
            mobile_view.add_available_field(created_by_field_definition.dup, :detail)
          end

          if mobile_view.all_detail_view_fields.where(field_name: 'updated_by').blank?
            mobile_view.add_available_field(updated_by_field_definition.dup, :detail)
          end
        end

      end
    end # End loop

    [created_by_field_definition, updated_by_field_definition].each do |field|
      field.destroy
    end

  end # End self.up

  def self.down
    #remove data here
  end

end
