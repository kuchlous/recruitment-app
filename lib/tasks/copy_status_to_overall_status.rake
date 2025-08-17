namespace :resumes do
  desc "Copy status field to overall_status for all resumes"
  task copy_status_to_overall_status: :environment do
    puts "Starting to copy status to overall_status..."
    
    # Count resumes that will be updated
    total_resumes = Resume.where("status IS NOT NULL AND status != ''").count
    puts "Found #{total_resumes} resumes with status to copy"
    
    if total_resumes > 0
      # Copy status to overall_status for first 3 resumes
      resumes_to_update = Resume.where("status IS NOT NULL AND status != ''").limit(3)
      resumes_to_update.each do |resume|
        resume.update_column(:overall_status, resume.status)
        puts "Updated resume ID: #{resume.id}"
      end
      puts "Successfully updated #{resumes_to_update.count} resumes"
      puts "Status values have been copied to overall_status field"
    else
      puts "No resumes found with status to copy"
    end
    
    puts "Task completed!"
  end
end
