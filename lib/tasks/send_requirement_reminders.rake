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
  desc 'Send weekly summary to Hiring Managers for requirements open > 3 business days with no projection'
  task :hm_requirement_summary => :environment do

    # Build HM => [requirements] mapping
    hm_to_requirements = Hash.new { |h, k| h[k] = [] }
    open_requirements = Requirement.where(status: ['OPEN', 'HOLD'])
    open_requirements.each do |requirement|
      next if requirement.employee.nil? # HM must exist
      no_of_business_days = business_days_between(requirement.last_forward_recieved, Date.today)

      next if no_of_business_days <= 3
      hm_to_requirements[requirement.employee] << requirement
    end

    hm_to_requirements.each do |hm, reqs|
      next if reqs.size == 0
      Emailer.weekly_hm_requirement_summary(hm, reqs).deliver_now
      puts "Sent weekly HM summary to #{hm.name} (#{hm.email}) with #{reqs.size} requirement(s)."
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