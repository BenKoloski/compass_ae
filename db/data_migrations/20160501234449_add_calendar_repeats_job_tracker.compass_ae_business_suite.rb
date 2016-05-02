# This migration comes from compass_ae_business_suite (originally 20151105183216)
class AddCalendarRepeatsJobTracker
  
  def self.up
    JobTracker.create(
        :job_name => 'Calendar Repeats Job',
        :job_klass => 'CompassAeBusinessSuite::DelayedJobs::CalendarRepeatsJob'
    )
  end
  
  def self.down
    JobTracker.find_by_job_klass('CompassAeBusinessSuite::DelayedJobs::CalendarRepeatsJob').destroy
  end

end
