# This migration comes from master_data_management (originally 20150217113159)
class AddSystemPollJobTracker

  def self.up
    JobTracker.create(
        :job_name => 'External Systems Poll',
        :job_klass => 'MasterDataManagement::DelayedJobs::PollExternalSystemsJob'
    )

  end

  def self.down
    JobTracker.find_by_job_klass('MasterDataManagement::DelayedJobs::PollExternalSystemsJob').destroy
  end

end
