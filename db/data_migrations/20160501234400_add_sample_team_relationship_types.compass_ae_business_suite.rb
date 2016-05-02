# This migration comes from compass_ae_business_suite (originally 20150122203601)
class AddSampleTeamRelationshipTypes
  
  def self.up
    from_role = RoleType.find_by_internal_identifier('team')

    to_role = RoleType.find_by_internal_identifier('player')

    RelationshipType.create(:description => 'Team Players',
                            :name => 'Team Players',
                            :internal_identifier => 'team_player',
                            :valid_from_role => from_role,
                            :valid_to_role => to_role
    )

    to_role = RoleType.find_by_internal_identifier('coach')
    RelationshipType.create(:description => 'Team Coaches',
                            :name => 'Team Coaches',
                            :internal_identifier => 'team_coach',
                            :valid_from_role => from_role,
                            :valid_to_role => to_role
    )

    to_role = RoleType.find_by_internal_identifier('peripheral_member')
    RelationshipType.create(:description => 'Team Peripheral Members',
                            :name => 'Team Peripheral Members',
                            :internal_identifier => 'team_peripheral',
                            :valid_from_role => from_role,
                            :valid_to_role => to_role
    )
  end
  
  def self.down
    #remove data here
  end

end
