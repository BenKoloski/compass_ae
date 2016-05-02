# This migration comes from compass_ae_business_suite (originally 20150226164610)
class AddWorkOrderTrackedStatuses

  def self.up
    order_statuses = TrackedStatusType.create(internal_identifier: 'work_order_statuses', description: 'Work Order Statuses')

    [
        ['draft', 'Draft'],
        ['open', 'Open'],
        ['closed', 'Closed'],
        ['canceled', 'Canceled'],
    ].each do |data|
      status = TrackedStatusType.create(internal_identifier: data[0], description: data[1])
      status.move_to_child_of(order_statuses)
    end

  end

  def self.down
    TrackedStatusType.find_by_internal_identifier('work_order_statuses').destroy
  end

end
