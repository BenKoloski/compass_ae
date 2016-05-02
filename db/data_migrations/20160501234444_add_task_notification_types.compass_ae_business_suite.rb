# This migration comes from compass_ae_business_suite (originally 20150819203343)
class AddTaskNotificationTypes
  
  def self.up
    %w{task_created task_updated task_comment_added task_assigned task_unassigned}.each do |iid|
      if NotificationType.iid(iid).nil?
        NotificationType.create(internal_identifier: iid, description: iid.humanize)
      end
    end
  end
  
  def self.down
    %w{task_created task_updated task_comment_added task_assigned task_unassigned}.each do |iid|
      unless NotificationType.iid(iid).nil?
        NotificationType.iid(iid).destroy
      end
    end
  end

end
