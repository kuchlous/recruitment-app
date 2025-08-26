namespace :requirements do
  desc "Generate embedding vector for a requirement description and save to Elasticsearch"
  task :generate_embedding, [:requirement_id] => :environment do |task, args|
    requirement_id = args[:requirement_id]
    
    if requirement_id.blank?
      puts "Usage: rake requirements:generate_embedding[REQUIREMENT_ID]"
      puts "Example: rake requirements:generate_embedding[123]"
      exit 1
    end
    
    # Find the requirement
    requirement = Requirement.find_by(id: requirement_id)
    if requirement.nil?
      puts "Error: Requirement with ID #{requirement_id} not found"
      exit 1
    end
    
    puts "Processing requirement: #{requirement.name} (ID: #{requirement.id})"
    
    begin
      # Generate and save embedding using the model method
      if requirement.generate_and_save_embedding
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
  
  desc "Generate embeddings for all requirements"
  task generate_all_embeddings: :environment do
    requirements = Requirement.all
    total_requirements = requirements.count
    
    puts "Starting to generate embeddings for #{total_requirements} requirements..."
    
    requirements.each_with_index do |requirement, index|
      puts "Processing #{index + 1}/#{total_requirements}: #{requirement.name} (ID: #{requirement.id})"
      
      begin
        # Generate and save embedding using the model method
        if requirement.generate_and_save_embedding
          puts "  ✓ Successfully processed requirement #{requirement.id}"
        end
        
        # Add a small delay to avoid rate limiting
        sleep(0.1)
        
      rescue => e
        puts "  ✗ Error processing requirement #{requirement.id}: #{e.message}"
        next
      end
    end
    
    puts "Completed processing #{total_requirements} requirements"
  end
  
end
