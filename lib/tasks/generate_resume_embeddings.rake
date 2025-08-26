namespace :resumes do
  desc "Generate embedding vector for a resume and save to Elasticsearch"
  task :generate_embedding, [:resume_id] => :environment do |task, args|
    resume_id = args[:resume_id]
    
    if resume_id.blank?
      puts "Usage: rake resumes:generate_embedding[RESUME_ID]"
      puts "Example: rake resumes:generate_embedding[123]"
      exit 1
    end
    
    # Find the resume
    resume = Resume.find_by(id: resume_id)
    if resume.nil?
      puts "Error: Resume with ID #{resume_id} not found"
      exit 1
    end
    
    puts "Processing resume: #{resume.name} (ID: #{resume.id})"
    
    begin
      # Generate and save embedding using the model method
      if resume.generate_and_save_embedding
        puts "Successfully generated and saved embedding to Elasticsearch"
      else
        puts "Error: Failed to generate or save embedding"
        exit 1
      end
      
      puts "Successfully saved embedding to Elasticsearch"
      
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
      exit 1
    end
  end
  
  desc "Generate embeddings for all resumes"
  task generate_all_embeddings: :environment do
    resumes = Resume.all
    total_resumes = resumes.count
    
    puts "Starting to generate embeddings for #{total_resumes} resumes..."
    
    resumes.each_with_index do |resume, index|
      puts "Processing #{index + 1}/#{total_resumes}: #{resume.name} (ID: #{resume.id})"
      
      begin
        # Generate and save embedding using the model method
        if resume.generate_and_save_embedding
          puts "  ✓ Successfully processed resume #{resume.id}"
        end
        
        # Add a small delay to avoid rate limiting
        sleep(0.1)
        
      rescue => e
        puts "  ✗ Error processing resume #{resume.id}: #{e.message}"
        next
      end
    end
    
    puts "Completed processing #{total_resumes} resumes"
  end
  
  desc "Generate embeddings for resumes with specific status"
  task :generate_embeddings_by_status, [:status] => :environment do |task, args|
    status = args[:status]
    
    if status.blank?
      puts "Usage: rake resumes:generate_embeddings_by_status[STATUS]"
      puts "Example: rake resumes:generate_embeddings_by_status[OPEN]"
      puts "Available statuses: OPEN, SHORTLISTED, SCHEDULED, REJECTED, YTO, HOLD, OFFERED, JOINING"
      exit 1
    end
    
    # Find resumes with the specified status
    resumes = Resume.joins(:req_matches).where(req_matches: { status: status.upcase }).distinct
    total_resumes = resumes.count
    
    if total_resumes == 0
      puts "No resumes found with status: #{status}"
      exit 1
    end
    
    puts "Starting to generate embeddings for #{total_resumes} resumes with status: #{status.upcase}"
    
    resumes.each_with_index do |resume, index|
      puts "Processing #{index + 1}/#{total_resumes}: #{resume.name} (ID: #{resume.id}) - Status: #{status.upcase}"
      
      begin
        # Generate and save embedding using the model method
        if resume.generate_and_save_embedding
          puts "  ✓ Successfully processed resume #{resume.id}"
        end
        
        # Add a small delay to avoid rate limiting
        sleep(0.1)
        
      rescue => e
        puts "  ✗ Error processing resume #{resume.id}: #{e.message}"
        next
      end
    end
    
    puts "Completed processing #{total_resumes} resumes with status: #{status.upcase}"
  end
  
end