# This migration comes from master_data_management (originally 20150211003450)
class AddSyncOperationStatuses
  
  def self.up
    sync_operations = TrackedStatusType.create(description: 'Sync Operations', internal_identifier: 'sync_operations')

    ['Pending', 'In Progress', 'Complete', 'Error'].each do |status|
      _status = TrackedStatusType.create(description: status, internal_identifier: status.underscore)
      _status.move_to_child_of(sync_operations)
    end
  end
  
  def self.down
    TrackedStatusType.iid('sync_operations').destroy
  end

end
