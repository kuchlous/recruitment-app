task :send_probation_mail => :environment do
    employees=Employee.where("joining_date = ?", 
      Date.new(166.days.ago.year, 166.days.ago.month, 166.days.ago.day)).where(employee_status: "ACTIVE")
    employees.each do |employee|
      puts employee.name
      Emailer.send_for_probation_decision(employee).deliver_now
    end    
end
