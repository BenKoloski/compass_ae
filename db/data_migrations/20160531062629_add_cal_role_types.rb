class AddCalRoleTypes

	def self.up
		RoleType.create(inerternal_identifier: 'appointment_requester', description: 'Appointment Requester')
		RoleType.create(inerternal_identifier: 'service_provider', description: 'Serice Provider')
	end

	def self.down
    	RoleType.iid('appointment_requester').destroy
    	RoleType.iid('service_provider').destroy
	end

end
