# This migration comes from compass_ae_business_suite (originally 20150126201408)
class AddProductFeatureValuesBusinessModule

  def self.up

    # create the module
    new_module = BusinessModule.create(
      description: 'Product Feature Values',
      internal_identifier: 'product_feature_values',
      data_manager_name: 'ProductFeatureValues',
      root_model: 'ProductFeatureValue',
      can_create: true,
      can_associate: true,
      is_template: true
    )

    # setup organizer view
    organizer_view = OrganizerView.new(
      description: 'ProductFeatureValues Organizer Template',
      title: 'Product Feature Values Organizer Template',
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
      description: 'Product Feature Values Web View Template',
      title: 'Product Feature Values Web View Template',
      can_edit_detail_view: true,
      can_edit_list_view: true
    )

    web_view.meta_data = {}

    new_module.dynamic_ui_components << web_view
    new_module.save

    # add fields
    [
      ['Internal Description', 'internal_description', 'text', []],
      ['External Description', 'external_description', 'text', []],

    ].each do |args|
      label = args[0]
      field_name = args[1]
      field_type = args[2]
      select_options = args[3]

      field_definition = FieldDefinition.new({
        field_name: field_name,
        label: label,
        field_type: FieldType.iid(field_type),
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
    %w{internal_description external_description}.each do |field_iid|
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
  end
end
