desc 'Performs payouts'
task :payouts => :environment do
  payouts = Event.perform_payouts!
  puts "Performed #{payouts.length} payout(s)"
end
