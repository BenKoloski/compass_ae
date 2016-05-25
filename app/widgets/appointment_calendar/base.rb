module Widgets
  module AppointmentCalendar
    class Base < ErpApp::Widgets::Base
  
      def index
        render :view => :index
      end

      def get_events
        my_appointments, not_my_appointments = nil

        if current_user
          party_id     = User.find(current_user).party.id
          role_type_id = RoleType.find_by_internal_identifier('appointment_requester').id

          appointments    = CalendarEvent.appointments.joins(cal_evt_party_roles: :role_type)
          my_appointments = appointments.where(cal_evt_party_roles: {party_id: party_id, role_type_id: role_type_id})
          not_my_appointments = appointments - my_appointments
        end

        availability_slots = CalendarEvent.availability_slots

        return :json => { 
          success: true,
          my_appointments: my_appointments,
          not_my_appointments: not_my_appointments,
          availability_slots: availability_slots
        }
      end

      def create_event
        event = CalendarEvent.new
        event.starttime = DateTime.new params[:start]
        event.endtime = DateTime.new params[:end]
        return :json => {success: true}
      end
  
      #should not be modified
      #modify at your own risk
      def locate
        File.dirname(__FILE__)
      end
  
      class << self
        def title
          "Appointment Calendar"
        end
    
        def widget_name
          File.basename(File.dirname(__FILE__))
        end
      end
    end#Base
  end # AppointmentCalendar
end # Widgets
