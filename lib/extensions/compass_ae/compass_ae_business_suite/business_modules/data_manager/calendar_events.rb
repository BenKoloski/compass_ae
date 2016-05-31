module CompassAeBusinessSuite
  module BusinessModules
    module DataManager

      # Handles all data mapping between the UI layer and the CompassAE persistence layer.

      class CalendarEvents < Base

      	class << self
          def default_name
            {
              service_provider: 'Service Provider',
              appointment_requester: 'Customer'
            }
          end
        end

        # def search filters, exclude_associated_records
        #   Appointment.where(true)
        # end

        def show_appointment_requester(record, field, fields_hash)
        	list_role_type(:appointment_requester, record)
        end

        def show_service_provider(record, field, fields_hash)
        	list_role_type(:service_provider, record)
        end

        def list_appointment_requester(record, field, fields_hash)
          list_role_type(:appointment_requester, record)
          'asdf'
        end

        def list_service_provider(record, field, fields_hash)
          list_role_type(:service_provider, record)
        end

        def create_appointment_requester(record, field_value)
          cepr = CalEvtPartyRole.new
          cepr.calendar_event = record
          cepr.role_type_id = RoleType.iid('appointment_requester').id
          cepr.party_id = field_value
          cepr.save
        end

        def create_service_provider(record, field_value)
          cepr = CalEvtPartyRole.new
          cepr.calendar_event = record
          cepr.role_type_id = RoleType.iid('service_provider').id
          cepr.party_id = field_value
          cepr.save
        end

        def list_role_type(role_type, record)
          name  = self.class.default_name[role_type.to_sym]
          roles = record.cal_evt_party_roles

          if roles.first
            role = roles.where(role_type_id: RoleType.iid(role_type).id)
            if role.first
              name = role.first.party.description
            end
          end

          name
        end
      	
      end # CalendarEvents

    end # DataManager
  end # BusinessModules
end # CompassAeBusinessSuite
  
