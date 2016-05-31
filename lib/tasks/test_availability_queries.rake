require 'benchmark'

namespace :test_availability_queries do
	task is_available: :environment do
		puts AvailabilitySlot.all.length
		puts Benchmark.measure {
			"a"*1_000_000
		}
	end
end
