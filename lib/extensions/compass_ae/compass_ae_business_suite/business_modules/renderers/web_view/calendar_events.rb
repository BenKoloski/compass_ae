module CompassAeBusinessSuite
  module BusinessModules
    module Renderers
      module WebView

        # This class implements how the Web View for a given Business Module is rendered.  There are
        # default implementations for each view List, Show and Edit.  If the Business Module requires
        # custom rendering this where it would be implemented.
        #
        # The class has the following instance variables
        #
        # @action_view - Reference to Rails ActionView
        # @current_user - Reference to the current user if a user is logged in.
        # @ui_component - Reference to the DynamicUiComponent that is being rendered
        # @record - Reference to the selected record if a record has been selected in the List View
        # @field_renderer - Reference to an instance of the FieldRenderer class which is used ot render custom fields and any custom field types
        #
        # You can choose to implement all or none of the methods below to add custom functionality.  They all have default behavior.

        class CalendarEvents < Base

          # Used to render the display only detail view.  All fields rendered as readonly display fields
          # def render_detail_show
          # end

          # Used to render the editable detail view.  All fields are editable.
          # def render_detail_form(action)
          # end

          # Used to render the List View
          # def render_list_view
          # end

        end # CalendarEvents

      end # WebView
    end # Renderers
  end # BusinessModules
end # CompassAeBusinessSuite
