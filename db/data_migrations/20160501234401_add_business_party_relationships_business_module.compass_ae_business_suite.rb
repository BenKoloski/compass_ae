# This migration comes from compass_ae_business_suite (originally 20150123184138)
class AddBusinessPartyRelationshipsBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
        description: 'Business Party Relationships',
        internal_identifier: 'business_party_relationships',
        data_manager_name: 'BusinessPartyRelationships',
        root_model: 'PartyRelationship',
        can_create: false,
        can_associate: true,
        is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
        description: 'Business Party Relationships Organizer Template',
        title: 'Business Party Relationships Organizer Template',
        icon_src: '/assets/erp_app/shared/default-app-shortcut.png',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    organizer_view.meta_data = {
        ext_js:{
        }
    }
    new_module.dynamic_ui_components << organizer_view
    new_module.save

    # setup web view
    web_view = WebView.new(
        description: 'Business Party Relationships Web View Template',
        title: 'Business Party Relationships Web View Template',
        can_edit_detail_view: true,
        can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
        ['Relationship Type', 'relationship_type', 'relationship_type', []],
        ['To Role', 'to_role', 'role_type', []],
        ['From Date', 'from_date', 'date', []],
        ['To Date', 'thru_date', 'date', []],
        ['To Party', 'to_party', 'business_party', []]
    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      select_options = args[3]

      field_definition = FieldDefinition.new({
                                                 field_name: field_name,
                                                 label: label,
                                                 field_type: FieldType.iid(field_type),
                                                 locked: true,
                                                 is_custom: false
                                             })

      # add select options if they are present
      unless select_options.empty?
        field_definition.select_options = args[3]
      end

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
    %w{relationship_type to_role from_date thru_date to_party}.each do |field_iid|
      description_list_view_field = organizer_view.available_list_view_fields.where('field_name = ?', field_iid).first
      description_list_view_field.added_to_view = true
      description_list_view_field.save

      details_field_set.add_field(organizer_view.available_detail_view_fields.where('field_name = ?', field_iid).first, 1)
      details_field_set.save
    end

    organizer_view.field_sets << details_field_set
    organizer_view.save

  end

  def self.down
    BusinessModule.where('internal_identifier = ? or parent_module_type = ?', 'business_party_relationships', 'business_party_relationships').destroy_all
  end
end
