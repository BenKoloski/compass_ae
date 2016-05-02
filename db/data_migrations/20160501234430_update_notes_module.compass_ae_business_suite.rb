# This migration comes from compass_ae_business_suite (originally 20150612202353)
class UpdateNotesModule
  def self.up
    # update any existing notes2 modules
    BusinessModule.where('parent_module_type = ? or parent_module_type = ?', 'notes2', 'notes').each do |notes_module|
      notes_module.parent_module_type = 'notes'
      notes_module.data_manager_name = 'Notes'

      if notes_module.meta_data['ext_js'] and notes_module.meta_data['ext_js']['xtype']
        notes_module.meta_data['ext_js']['xtype'] = 'noteslistview'
      end

      notes_module.meta_data['ext_js']['noteTypeIds'] = notes_module.meta_data['note_type_ids'] || notes_module.meta_data['note_type_id']

      notes_module.save

      organizer_view = notes_module.organizer_view
      if organizer_view.meta_data['ext_js'] and organizer_view.meta_data['ext_js']['xtype']
        organizer_view.meta_data['ext_js']['xtype'] = 'noteslistview'
      end
      organizer_view.meta_data['ext_js'].delete('baseURL')
      organizer_view.save
    end

    # update notes2 to be notes
    notes2 = BusinessModule.templates.where('internal_identifier = ?', 'notes2').first
    if notes2
      # remove old module
      BusinessModule.templates.where('internal_identifier = ?', 'notes').first.destroy

      notes2.internal_identifier = 'notes'
      notes2.data_manager_name = 'Notes'
      notes2.description = 'Notes'
      notes2.save

      if notes2.meta_data['ext_js'] and notes2.meta_data['ext_js']['xtype']
        notes2.meta_data['ext_js']['xtype'] = 'noteslistview'
      end
      notes2.save

      organizer_view = notes2.organizer_view
      if organizer_view.meta_data['ext_js'] and organizer_view.meta_data['ext_js']['xtype']
        organizer_view.meta_data['ext_js']['xtype'] = 'noteslistview'
      end
      organizer_view.meta_data['ext_js'].delete('baseURL')
      organizer_view.save
    end
  end

  def self.down
    #remove data here
  end
end
