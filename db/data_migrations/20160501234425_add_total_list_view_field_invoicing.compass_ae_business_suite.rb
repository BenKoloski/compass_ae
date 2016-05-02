# This migration comes from compass_ae_business_suite (originally 20150421172936)
class AddTotalListViewFieldInvoicing
  
  def self.up
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'invoicing', 'invoicing').each do |biz_module|
      total_field = FieldDefinition.new({
                                            field_name: 'total',
                                            label: 'Total',
                                            locked: true,
                                            field_type: FieldType.iid('display'),
                                        })

      total_field.save

      biz_module.organizer_view.add_available_field(total_field, :list)

      list_view_field = biz_module.organizer_view.available_list_view_fields.where('field_name = ?', 'total').first
      list_view_field.added_to_view = true
      list_view_field.save
    end
  end
  
  def self.down
    #remove data here
  end

end
