module CompassAeBusinessSuite
  module BusinessModules
    module Creator
      class CalendarEvents < Base

        def create_module
          # build default module
          new_module = super

          meta_data = {
              calendar_event_type: @params[:calendar_event_type]
          }

          ext_js_data = {
              calendarEventType: @params[:calendar_event_type]
          }

          new_module.meta_data = new_module.meta_data.merge!(meta_data)
          new_module.meta_data['ext_js'] = new_module.meta_data['ext_js'].merge!(ext_js_data)
          new_module.save

          new_module
        end

      end # CalendarEvents
    end # Creator
  end # BusinessModules
end # CompassAeBusinessSuite
