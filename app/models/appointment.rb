class Appointment < CalendarEvent
	belongs_to :availability_slot, class_name: 'AvailabilitySlot', foreign_key: 'parent_id'
		has_many :cal_evt_party_roles 

end