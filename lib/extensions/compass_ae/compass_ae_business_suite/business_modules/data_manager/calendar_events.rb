module CompassAeBusinessSuite
  module BusinessModules
    module DataManager

      # Handles all data mapping between the UI layer and the CompassAE persistence layer.

      class CalendarEvents < Base

        def after_create record
          event_type = CalendarEventType.iid(business_module.meta_data['calendar_event_type'])
          record.calendar_event_type = event_type
          if (event_type.internal_identifier == 'cal_appointment')
            record.type = 'Appointment'
          elsif (event_type.internal_identifier == 'cal_availability')
            record.type = 'AvailabilitySlot'
          end
          record.save!
        end

      	class << self
          def default_name
            {
              service_provider: 'Service Provider',
              appointment_requester: 'Customer'
            }
          end
        end

                def update_appointment_requester(record, field_value)
          cepr = record.cal_evt_party_roles.where(role_type_id: RoleType.iid('appointment_requester').id).first
          cepr.party_id = field_value
          cepr.save
        end

        def update_service_provider(record, field_value)
          cepr = record.cal_evt_party_roles.where(role_type_id: RoleType.iid('service_provider').id).first
          cepr.party_id = field_value
          cepr.save
        end

        def scope_by_party(parent_record, parent_business_module, exclude_associated_records, statement)
          CalendarEvent.joins(:cal_evt_party_roles).where(cal_evt_party_roles: {party_id: parent_record.id})
        end

        def search filters, exclude_associated_records
          klass = nil
          if business_module.meta_data['calendar_event_type'] == 'cal_appointment'
            klass = Appointment
          elsif business_module.meta_data['calendar_event_type'] == 'cal_availability'
            klass= AvailabilitySlot
          end
          klass
        end

        def show_appointment_requester(record, field, fields_hash)
          Party.joins(:cal_evt_party_roles).where(cal_evt_party_roles: {calendar_event_id: record.id, role_type_id: RoleType.iid('appointment_requester').id}).first
        end

        def show_service_provider(record, field, fields_hash)
          Party.joins(:cal_evt_party_roles).where(cal_evt_party_roles: {calendar_event_id: record.id, role_type_id: RoleType.iid('service_provider').id}).first
        end

        def list_appointment_requester(record, field, fields_hash)
          Party.joins(:cal_evt_party_roles).where(cal_evt_party_roles: {calendar_event_id: record.id, role_type_id: RoleType.iid('appointment_requester').id}).first
        end

        def list_service_provider(record, field, fields_hash)
          Party.joins(:cal_evt_party_roles).where(cal_evt_party_roles: {calendar_event_id: record.id, role_type_id: RoleType.iid('service_provider').id}).first
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
      	
      end # CalendarEvents

    end # DataManager
  end # BusinessModules
end # CompassAeBusinessSuite
  
