namespace :eta_based_mail do
    desc 'Req stays open with No projection for > 3 days >> Send mail to Engineering/TA head'
    task :send_requirement_reminders => :environment do
        Requirement.all.each do |requirement|
           no_of_business_days = business_days_between( requirement.last_forward_recieved, Date.today)
           if !no_of_business_days.nil? && no_of_business_days  > 3
              # Send mail to Engineering/TA head 
              Emailer.send_requirement_reminder(requirement).deliver_now
           end
        end

    end

    def business_days_between(date1, date2)
        return nil if date1.nil?
        business_days = 0
        # byebug
        date = date2
        while date > date1
        business_days = business_days + 1 unless date.saturday? or date.sunday?
        date = date - 1.day
        end
        business_days
    end
end