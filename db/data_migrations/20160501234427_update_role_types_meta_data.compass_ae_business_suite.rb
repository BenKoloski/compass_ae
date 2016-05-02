# This migration comes from compass_ae_business_suite (originally 20150605203212)
class UpdateRoleTypesMetaData

  def self.up
    BusinessModule.all.each do |business_module|

      meta_data = business_module.meta_data

      if meta_data.has_key? 'party_role'
        role_types = meta_data['party_role']
        meta_data['role_types'] = role_types
        meta_data.delete('party_role')
        business_module.save!
      end

      if meta_data.has_key?('ext_js') and meta_data['ext_js'].has_key?('partyRole')
        role_types = meta_data['ext_js']['partyRole']
        meta_data['ext_js']['roleTypes'] = role_types
        meta_data['ext_js'].delete('partyRole')
        business_module.save!
      end
    end
  end

  def self.down
    #remove data here
  end

end
