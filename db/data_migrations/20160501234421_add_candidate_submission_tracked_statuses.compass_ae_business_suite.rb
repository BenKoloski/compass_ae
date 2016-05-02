# This migration comes from compass_ae_business_suite (originally 20150410160537)
class AddCandidateSubmissionTrackedStatuses < ActiveRecord::Migration
  def self.up
    candidate_submission_statuses = TrackedStatusType.create(internal_identifier: 'customer_candidate_submission_statuses', description: 'Customer Candidate Submission Statuses')

    [
        ['accepted', 'Accepted'],
        ['declined', 'Declined'],
        ['tbd', 'TBD']
    ].each do |data|
      status = TrackedStatusType.create(internal_identifier: data[0], description: data[1])
      status.move_to_child_of(candidate_submission_statuses)
    end

    candidate_submission_statuses = TrackedStatusType.create(internal_identifier: 'vendor_candidate_submission_statuses', description: 'Vendor Candidate Submission Statuses')

    [
        ['submitted', 'Submitted'],
        ['declined', 'Declined'],
        ['tbd', 'TBD']
    ].each do |data|
      status = TrackedStatusType.create(internal_identifier: data[0], description: data[1])
      status.move_to_child_of(candidate_submission_statuses)
    end

  end

  def self.down
    TrackedStatusType.find_by_internal_identifier('customer_candidate_submission_statuses').destroy
    TrackedStatusType.find_by_internal_identifier('vendor_candidate_submission_statuses').destroy
  end

end