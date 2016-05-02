# This migration comes from erp_work_effort (originally 20150824152639)
class AddSequenceToWorkEffort < ActiveRecord::Migration
  def up
    add_column :work_efforts, :sequence, :integer, default: 0 unless column_exists? :work_efforts, :sequence
  end

  def down
    remove_column :work_efforts, :sequence, :integer, default: 0 if column_exists? :work_efforts, :sequence
  end
end
