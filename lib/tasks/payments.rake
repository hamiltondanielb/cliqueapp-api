desc 'Performs payouts'
task :payouts => :environment do
  payouts = Event.perform_payouts!
  puts "Performed #{payouts.length} payout(s)"
end

desc 'Performs refunds'
task :refunds => :environment do
  registrations = EventRegistration.perform_refunds!
  puts "Refunded #{registrations.length} users"
end

desc 'Notifies of cancellations'
task :notify_of_cancellations => :environment do
  registrations = EventRegistration.notify_of_cancellations!
  puts "Notified #{registrations.length} users"
end
