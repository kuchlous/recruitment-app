# lib/tasks/seed_interview_skills.rake

namespace :db do
  namespace :seed do
    desc "Seed interview skills from the provided list"
    task interview_skills: :environment do
      puts "Starting to seed interview skills..."
      
      raw_skills = [
        "C++",
        "Data Structure",
        "Algorithm",
        "Machine Learning",
        "Deep Learning",
        "Computer Vision",
        "Python",
        "Power BI",
        "SQL",
        "Tableau",
        "C",
        "Linux Driver Development",
        "ARM",
        "JTAG",
        "Linux/Android",
        "Graphics/Video/Camera/Display/H.265/V4L2",
        "Firmware Development",
        "RTOS",
        "SOC",
        "Python Automation with Linux Device Drivers",
        "WLAN Development",
        "BT Stack/BT Profile Development",
        "WLAN Testing",
        "Bluetooth Profile/Stack Testing",
        "Embedded C",
        "Jenkins",
        "Yocto/RPM/Debian/CMake",
        "Android NDK",
        "Baremetal/Low Level Drivers",
        "Data Structures",
        "Linux Internal",
        "AUTOSAR (MCAL Drivers/CDD)",
        "Modem Testing/LTE Testing",
        "4G/5G Testing with Python",
        "Python Automation",
        "PyTest",
        "Java Full Stack",
        "Node.js Full Stack",
        "C# Full Stack",
        "Python Full Stack",
        "React",
        "Angular",
        "Vue.js",
        "JavaScript",
        "Java",
        "Node.js",
        "Next.js",
        "C#",
        "Web Automation",
        "Cypress",
        "Mobile Automation",
        "SQL/MySQL",
        "Oracle Database",
        "Python Selenium",
        "OOP",
        "Robotics",
        "CI/CD",
        "Jenkins",
        "Kubernetes",
        "ETL",
        "Azure",
        "AWS",
        "Jira",
        "Excel",
        "Scrum",
        "Agile",
        "Project Management",
        "Budgeting",
        "Planning",
        "PMP",
        "PNP",
        "CPU/GPU",
        "Linux Benchmarking",
        "Validation"
      ]

      # Remove duplicates and sort
      final_skills = raw_skills.uniq.sort

      puts "Total unique skills to process: #{final_skills.count}"
      puts "\nSkills list:"
      final_skills.each_with_index { |skill, i| puts "#{i+1}. #{skill}" }
      
      # Track statistics
      created_count = 0
      existing_count = 0

      # Create or update skills
      final_skills.each do |skill_name|
        # Skip if empty
        next if skill_name.strip.empty?

        # Check if skill already exists (case-insensitive)
        existing_skill = InterviewSkill.where('LOWER(name) = LOWER(?)', skill_name.strip).first
        
        if existing_skill
          # Skill already exists
          existing_count += 1
          puts "✓ Skill already exists: #{skill_name}"
        else
          # Create new skill
          InterviewSkill.create!(name: skill_name.strip)
          created_count += 1
          puts "+ Created new skill: #{skill_name}"
        end
      rescue ActiveRecord::RecordInvalid => e
        puts "! Error creating skill '#{skill_name}': #{e.message}"
      rescue StandardError => e
        puts "! Unexpected error for skill '#{skill_name}': #{e.message}"
      end

      puts "\n" + "="*50
      puts "SEED COMPLETED!"
      puts "="*50
      puts "Total skills processed: #{final_skills.count}"
      puts "New skills created: #{created_count}"
      puts "Existing skills found: #{existing_count}"
      puts "="*50
      
      puts "\nAll skills in database (sorted alphabetically):"
      InterviewSkill.order(:name).each do |skill|
        puts "  - #{skill.name}"
      end
      
      puts "\nTotal skills in database: #{InterviewSkill.count}"
    end
  end
end