namespace :requirements do
  desc "Copy existing eng_lead data to eng_leads HABTM association"
  task copy_eng_lead_to_eng_leads: :environment do
    puts "Starting to copy eng_lead data to eng_leads association..."
    
    # Find all requirements that have an eng_lead_id set
    requirements_with_eng_lead = Requirement.where.not(eng_lead_id: nil)
    
    puts "Found #{requirements_with_eng_lead.count} requirements with eng_lead_id"
    
    copied_count = 0
    skipped_count = 0
    error_count = 0
    
    requirements_with_eng_lead.each do |requirement|
      begin
        if requirement.eng_lead_id.present?
          # Check if the employee exists
          employee = Employee.find_by(id: requirement.eng_lead_id)
          
          if employee.nil?
            puts "Warning: Employee with ID #{requirement.eng_lead_id} not found for requirement #{requirement.id} (#{requirement.name})"
            error_count += 1
            next
          end
          
          # Check if the association already exists
          if requirement.eng_leads.include?(employee)
            puts "Skipping: Requirement #{requirement.id} (#{requirement.name}) already has #{employee.name} as eng_lead"
            skipped_count += 1
            next
          end
          
          # Add the employee to eng_leads
          requirement.eng_leads << employee
          copied_count += 1
          
          puts "Copied: Requirement #{requirement.id} (#{requirement.name}) -> #{employee.name}"
        end
      rescue => e
        puts "Error processing requirement #{requirement.id}: #{e.message}"
        error_count += 1
      end
    end
    
    puts "\n=== Summary ==="
    puts "Total requirements processed: #{requirements_with_eng_lead.count}"
    puts "Successfully copied: #{copied_count}"
    puts "Skipped (already exists): #{skipped_count}"
    puts "Errors: #{error_count}"
    
    # Show some examples of the results
    puts "\n=== Sample Results ==="
    sample_requirements = Requirement.joins(:eng_leads).limit(5)
    sample_requirements.each do |req|
      eng_leads_names = req.eng_leads.map(&:name).join(', ')
      puts "Requirement: #{req.name} -> Eng Leads: #{eng_leads_names}"
    end
    
    puts "\nTask completed!"
  end
  
  desc "Show current eng_leads associations"
  task show_eng_leads: :environment do
    puts "Current eng_leads associations:"
    puts "=" * 50
    
    requirements_with_eng_leads = Requirement.joins(:eng_leads)
    
    if requirements_with_eng_leads.empty?
      puts "No requirements have eng_leads associations yet."
    else
      requirements_with_eng_leads.each do |requirement|
        eng_leads_names = requirement.eng_leads.map(&:name).join(', ')
        puts "Requirement: #{requirement.name}"
        puts "  Eng Leads: #{eng_leads_names}"
        puts "  Original eng_lead: #{requirement.eng_lead&.name || 'None'}"
        puts "-" * 30
      end
    end
    
    puts "\nSummary:"
    puts "Total requirements with eng_leads: #{requirements_with_eng_leads.count}"
    puts "Total requirements with original eng_lead: #{Requirement.where.not(eng_lead_id: nil).count}"
  end
  
  desc "Clear all eng_leads associations"
  task clear_eng_leads: :environment do
    puts "Clearing all eng_leads associations..."
    
    count = 0
    Requirement.all.each do |requirement|
      if requirement.eng_leads.any?
        requirement.eng_leads.clear
        count += 1
        puts "Cleared eng_leads for requirement: #{requirement.name}"
      end
    end
    
    puts "Cleared eng_leads for #{count} requirements"
  end
end 