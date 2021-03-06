# This migration comes from erp_tech_svcs (originally 20160310163060)
class AddCreatedByUpdatedByToErpTechSvcs < ActiveRecord::Migration
  def up
    %w{file_assets}.each do |table|

      unless column_exists? table.to_sym, :created_by_party_id
        add_column table.to_sym, :created_by_party_id, :integer

        add_index table.to_sym, :created_by_party_id, name: "#{table}_created_by_pty_idx"
      end

      unless column_exists? table.to_sym, :updated_by_party_id
        add_column table.to_sym, :updated_by_party_id, :integer

        add_index table.to_sym, :updated_by_party_id, name: "#{table}_updated_by_pty_idx"
      end

    end

  end

  def down
    %w{file_assets}.each do |table|

      if column_exists? table.to_sym, :created_by_party_id
        remove_column table.to_sym, :created_by_party_id
      end

      if column_exists? table.to_sym, :updated_by_party_id
        remove_column table.to_sym, :updated_by_party_id
      end
    end

  end

end
