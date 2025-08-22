namespace :ta_leads do
  desc "Copy existing ta_lead data to ta_leads HABTM association"
  task copy_ta_lead_to_ta_leads: :environment do
    puts "Starting to copy ta_lead data to ta_leads association..."
    
    # Get all requirements that have a ta_lead_id
    requirements_with_ta_lead = Requirement.where.not(ta_lead_id: [nil, 0])
    
    puts "Found #{requirements_with_ta_lead.count} requirements with ta_lead_id"
    
    count = 0
    requirements_with_ta_lead.each do |requirement|
      employee = Employee.find_by(id: requirement.ta_lead_id)
      
      if employee && employee.employee_status == "ACTIVE"
        # Check if the employee is already in ta_leads
        if requirement.ta_leads.include?(employee)
          puts "Employee #{employee.name} already in ta_leads for requirement: #{requirement.name}"
        else
          # Add the employee to ta_leads
          requirement.ta_leads << employee
          count += 1
          puts "Added #{employee.name} to ta_leads for requirement: #{requirement.name}"
        end
      else
        puts "Warning: Employee with ID #{requirement.ta_lead_id} not found or not active for requirement: #{requirement.name}"
      end
    end
    
    puts "Successfully added #{count} ta_leads associations"
    
    # Show some sample results
    puts "\nSample requirements with ta_leads:"
    sample_requirements = Requirement.joins(:ta_leads).limit(5)
    
    sample_requirements.each do |req|
      ta_leads_names = req.ta_leads.map(&:name).join(', ')
      puts "Requirement: #{req.name} -> TA Leads: #{ta_leads_names}"
    end
  end

  desc "Show current ta_leads associations"
  task show_ta_leads: :environment do
    puts "Current ta_leads associations:"
    
    requirements_with_ta_leads = Requirement.joins(:ta_leads)
    
    if requirements_with_ta_leads.empty?
      puts "No requirements have ta_leads associations yet."
    else
      requirements_with_ta_leads.each do |requirement|
        ta_leads_names = requirement.ta_leads.map(&:name).join(', ')
        puts "Requirement: #{requirement.name}"
        puts "  TA Leads: #{ta_leads_names}"
        puts "---"
      end
      
      puts "Total requirements with ta_leads: #{requirements_with_ta_leads.count}"
    end
  end

  desc "Clear all ta_leads associations"
  task clear_ta_leads: :environment do
    puts "Clearing all ta_leads associations..."
    
    count = 0
    Requirement.all.each do |requirement|
      if requirement.ta_leads.any?
        requirement.ta_leads.clear
        count += 1
        puts "Cleared ta_leads for requirement: #{requirement.name}"
      end
    end
    
    puts "Cleared ta_leads for #{count} requirements"
  end

  desc "Verify ta_leads join table structure"
  task verify_structure: :environment do
    puts "Verifying ta_leads join table structure..."
    
    # Check if the join table exists
    if ActiveRecord::Base.connection.table_exists?('requirements_ta_leads')
      puts "✅ requirements_ta_leads table exists"
      
      # Check table structure
      columns = ActiveRecord::Base.connection.columns('requirements_ta_leads')
      puts "Table columns:"
      columns.each do |col|
        puts "  - #{col.name}: #{col.type}"
      end
      
      # Check indexes
      indexes = ActiveRecord::Base.connection.indexes('requirements_ta_leads')
      puts "Table indexes:"
      indexes.each do |index|
        puts "  - #{index.name}: #{index.columns.join(', ')}"
      end
    else
      puts "❌ requirements_ta_leads table does not exist"
      puts "Please run: bundle exec rake db:migrate"
    end
  end
end
