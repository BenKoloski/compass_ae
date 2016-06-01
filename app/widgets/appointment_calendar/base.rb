module Widgets
  module AppointmentCalendar
    class Base < ErpApp::Widgets::Base

      def index
        @current_user = current_user
        render :view => :index
      end

      def get_events
        my_appointments, not_my_appointments = nil

        if current_user
          party_id     = User.find(current_user).party.id
          role_type_id = RoleType.find_by_internal_identifier('appointment_requester').id

          appointments    = Appointment.joins(cal_evt_party_roles: :role_type)
          my_appointments = appointments.where(cal_evt_party_roles: {party_id: party_id}).uniq
          not_my_appointments = (appointments - my_appointments).uniq
        else
          not_my_appointments = Appointment.all
        end

        

        availability_slots = AvailabilitySlot.all

        return :json => { 
          success: true,
          my_appointments: my_appointments || [],
          not_my_appointments: not_my_appointments || [],
          availability_slots: availability_slots || []
        }
      end

      def unschedule_event
        CalendarEvent.find(params[:id]).destroy
        return :json => {success: true}
      end

      def create_event
        event = Appointment.new
        params[:start] = params[:start].map {|el| el.to_i}
        params[:end] = params[:end].map {|el| el.to_i}
        event.starttime = DateTime.new params[:start][0], params[:start][1], params[:start][2], params[:start][3], params[:start][4]
        event.endtime = DateTime.new params[:end][0], params[:end][1], params[:end][2], params[:end][3], params[:end][4]
        event.calendar_event_type_id = CalendarEventType.find_by_internal_identifier('cal_appointment').id

        cepr = CalEvtPartyRole.new
        cepr.party_id = User.find(current_user).party.id
        cepr.role_type_id = RoleType.iid('appointment_requester').id
        cepr.calendar_event = event

        event.save
        cepr.save

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
