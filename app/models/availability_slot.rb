class AvailabilitySlot < CalendarEvent
	has_many :appointments, class_name: 'Appointment', foreign_key: 'parent_id'
		has_many :cal_evt_party_roles 


	def self.get_availabilities start_time, end_time
		times = []

		overlapping_avails = where('starttime < ? AND endtime > ?', end_time, start_time).order(:starttime)
		overlapping_avails.each do |avail|
			appts = avail.appointments.order(:starttime)
			res = appts.reduce([avail.to_date_range]) do |memo, appt|
				diff = disjunction(memo.last, appt.to_date_range)
				memo.pop
				memo + diff
			end
			times += res
		end
		times
	end

	def self.is_available start_time, end_time
		containing_avail = where('starttime <= ? AND endtime >= ?', start_time, end_time).first
		return false unless containing_avail
		overlapping_appts = containing_avail.appointments.where('starttime < ? AND endtime > ?', end_time, start_time)
		overlapping_appts.length > 0 ? false : true
	end

	def self.disjunction range_1, range_2
		res = []
		res << [range_1[0], range_2[0]] if range_1[0] < range_2[0]
		res << [range_2[1], range_1[1]] if range_1[1] > range_2[1]
		res
	end
end