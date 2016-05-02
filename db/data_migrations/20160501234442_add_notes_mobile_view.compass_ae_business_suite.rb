# This migration comes from compass_ae_business_suite (originally 20150817184431)
class AddNotesMobileView
  
  def self.up
    BusinessModule.where('parent_module_type = ?', 'notes').each do |notes_module|

      mobile_view = MobileView.new(
          description: 'Notes',
          title: 'Notes',
          icon_src: '/assets/erp_app/icons/business_party_64x64.png',
          can_edit_detail_view: true,
          can_edit_list_view: true
      )
      mobile_view.save

      notes_module.dynamic_ui_components << mobile_view

      [
          ['Content', 'content', 'text_area'],
          ['Created By', 'created_by', 'display']
      ].each do |args|
        label = args[0]
        field_name = args[1]
        field_type = args[2]
        field_definition = FieldDefinition.new({
                                                   field_name: field_name,
                                                   label: label,
                                                   field_type: FieldType.iid(field_type)
                                               })

        field_definition.save
        mobile_view.add_available_field(field_definition, :detail)
        mobile_view.add_available_field(field_definition.dup, :list)
      end

      mobile_detail_view = FieldSet.new(
          {
              field_set_name: 'mobile_detail_view',
              label: 'Mobile Detail View',
              columns: 1
          }
      )

      mobile_view.field_sets << mobile_detail_view
      mobile_view.save

      mobile_list_view = FieldSet.new(
          {
              field_set_name: 'mobile_list_view',
              label: 'Mobile List View',
              columns: 1
          }
      )

      mobile_view.field_sets << mobile_list_view
      mobile_view.save

      %w{content created_by}.each do |field_iid|
        mobile_detail_view.add_field(mobile_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        mobile_detail_view.save
      end

      %w{content created_by}.each do |field_iid|
        mobile_list_view.add_field(mobile_view.available_list_view_fields.where('field_name = ?', field_iid).first, 1)
        mobile_list_view.save
      end
    end
  end
  
  def self.down
    #remove data here
  end

end
