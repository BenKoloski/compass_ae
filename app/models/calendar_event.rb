class CalendarEvent < ActiveRecord::Base
	belongs_to :calendar_event_type
	scope :availability_slots, -> { where('calendar_event_type_id = ?', CalendarEventType.find_by_internal_identifier('cal_availability').id)}
  	scope :appointments, -> { where('calendar_event_type_id = ?', CalendarEventType.find_by_internal_identifier('cal_appointment').id)}
end