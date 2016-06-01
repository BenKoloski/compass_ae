module CompassAeBusinessSuite
  module BusinessModules
    module Associator
      class BusinessParty < Base
      	def associatable_module_types
      		
          super.concat([
              'accounts',
              'invoicing',
              'business_party',
              'transactions',
              'notes',
              'activity_stream',
              'party_skill',
              'position_fulfillment',
              'business_party_relationships',
              'orders',
              'payment_application',
              'work_orders',
              'product_types',
              'staffing_positions',
              'party_achievements',
              'education_history',
              'contact_mechanism',
              'tasks',
              'projects',
              'expenses',
              'files',
              'reports',
              'communication_events',
              'referrals',
              'referral_programs',
              'calendar_events'
          ])
        end
      end
  	end
  end
end