# This migration comes from compass_ae_business_suite (originally 20150331174714)
class AddNotesBusinessModule

  def self.up
    unless BusinessModule.templates.where('internal_identifier = ?', 'notes').first
      # create the module
      new_module = BusinessModule.create(
          description: 'Notes',
          internal_identifier: 'notes',
          data_manager_name: 'Notes',
          root_model: 'Note',
          can_create: true,
          can_associate: true,
          is_template: true
      )

      # setup organizer view
      organizer_view = OrganizerView.new(
          description: 'Notes Organizer',
          title: 'Notes Organizer',
          icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
          can_edit_detail_view: true,
          can_edit_list_view: true
      )

      organizer_view.meta_data = {
          ext_js: {
              xtype: 'noteslistview'
          }
      }
      new_module.dynamic_ui_components << organizer_view
      new_module.save

      # setup web view
      web_view = WebView.new(
          description: 'Notes Web View',
          title: 'Notes Web View',
          can_edit_detail_view: true,
          can_edit_list_view: true
      )

      web_view.meta_data = {}

      new_module.dynamic_ui_components << web_view
      new_module.save

      # add fields
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
                                                   field_type: FieldType.iid(field_type),
                                               })

        field_definition.save

        organizer_view.add_available_field(field_definition, :detail)
        organizer_view.add_available_field(field_definition.dup, :list)
        web_view.add_available_field(field_definition.dup, :detail)
        web_view.add_available_field(field_definition.dup, :list)
      end

      details_field_set = FieldSet.new({
                                           field_set_name: 'details',
                                           label: 'Details',
                                           columns: 1
                                       })

      # add fields to field set
      %w{content created_by}.each do |field_iid|
        description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
        description_list_view_field.added_to_view = true
        description_list_view_field.save

        details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
        details_field_set.save
      end

      organizer_view.field_sets << details_field_set
      organizer_view.save
    end
  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'notes', 'notes').destroy_all
  end
end
