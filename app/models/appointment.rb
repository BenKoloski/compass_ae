class Appointment < CalendarEvent
	belongs_to :availability_slot, class_name: 'AvailabilitySlot', foreign_key: 'parent_id'
	has_many :cal_evt_party_roles, foreign_key: 'calendar_event_id', dependent: :destroy
	has_many :calendar_invites, foreign_key: 'calendar_event_id'
	has_file_assets
end