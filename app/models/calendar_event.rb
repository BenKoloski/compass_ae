class CalendarEvent < ActiveRecord::Base
	belongs_to :calendar_event_type
	has_many :cal_evt_party_roles 
	has_many :parties, through: :cal_evt_party_roles

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