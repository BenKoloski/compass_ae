class CalendarEvent < ActiveRecord::Base
	belongs_to :calendar_event_type

	def to_date_range 
		[starttime, endtime]
	end

	def created_by_party
		Party.first
	end

	def updated_by_party
		Party.first
	end
end