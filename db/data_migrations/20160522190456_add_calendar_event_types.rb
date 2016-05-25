class AddCalendarEventTypes
  
  def self.up

    evt_type = CalendarEventType.new
    evt_type.description = "Availability"
    evt_type.internal_identifier = "cal_availability"
    evt_type.save

    evt_type = CalendarEventType.new
    evt_type.description = "Appointment"
    evt_type.internal_identifier = "cal_appointment"
    evt_type.save

  end
  
  def self.down
    CalendarEventType.iid('cal_availability').destroy
    CalendarEventType.iid('cal_appointment').destroy
  end

end
