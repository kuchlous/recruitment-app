namespace :eta_based_mail do
    desc 'Req stays open with No projection for > 3 days >> Send mail to Engineering/TA head'
    task :send_requirement_reminders => :environment do
        Requirement.all.each do |requirement|
           no_of_business_days = business_days_between(requirement.last_forward_recieved, Date.today)
           if no_of_business_days  > 3 && requirement.open_forwards.count < 1
              # Send mail to Engineering/TA head 
              Emailer.send_requirement_reminder(requirement).deliver_now
           end
        end
    end
end

# rake weekly:hm_requirement_summary
namespace :weekly do
  desc 'Send weekly summary to TA Leads for requirements open > 3 business days with no projection'
  task :ta_requirement_summary => :environment do

    # Build HM => [requirements] mapping
    ta_to_requirements = Hash.new { |h, k| h[k] = [] }
    open_requirements = Requirement.where(status: ['OPEN', 'HOLD'])
    open_requirements.each do |requirement|
      next if requirement.ta_leads.size == 0 # TA Leads must exist
      no_of_business_days = business_days_between(requirement.last_forward_recieved, Date.today)
      next if no_of_business_days <= 3
      requirement.ta_leads.each do |lead|
        ta_to_requirements[lead] << requirement
      end
    end
    ta_to_requirements.each do |ta, reqs|
      next if reqs.size == 0
      Emailer.weekly_ta_requirement_summary(ta, reqs).deliver_now
      puts "Sent weekly TA Lead summary to #{ta.name} (#{ta.email}) with #{reqs.size} requirement(s)."
    end
  end
end

def business_days_between(date1, date2)
  return -1 if date1.nil?
  business_days = 0
  date = date2
  while date > date1
    business_days += 1 unless date.saturday? || date.sunday?
    date = date - 1.day
  end
  business_days
end