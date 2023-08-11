task :send_probation_mail => :environment do
    puts "Sending probation reminders on #{Date.today}"
    employees=Employee.where("end_probation_date = ?", 
      Date.new(-15.days.ago.year, -15.days.ago.month, -15.days.ago.day)).where(employee_status: "ACTIVE")
    employees.each do |employee|
      puts employee.name
      Emailer.send_for_probation_decision(employee).deliver_now
    end    
end
