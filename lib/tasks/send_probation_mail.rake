task :send_probation_mail => :environment do
    employees=Employee.where("joining_date = ?",166.days.ago)
    employees.each do |employee|
      Emailer.send_for_probation_decision (employee)
    end    
end
