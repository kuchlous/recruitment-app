namespace :resumes do
  desc "Generate embedding vector for a resume and save to Elasticsearch"
  task :generate_embedding, [:resume_id] => :environment do |task, args|
    resume_id = args[:resume_id]
    
    if resume_id.blank?
      puts "Usage: rake resumes:generate_embedding[RESUME_ID]"
      puts "Example: rake resumes:generate_embedding[123]"
      exit 1
    end
    
    # Check if OpenAI API key is set
    openai_api_key = ENV['OPENAI_API_KEY']
    if openai_api_key.blank?
      puts "Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set it with: export OPENAI_API_KEY='your-api-key-here'"
      exit 1
    end
    
    # Find the resume
    resume = Resume.find_by(id: resume_id)
    if resume.nil?
      puts "Error: Resume with ID #{resume_id} not found"
      exit 1
    end
    
    puts "Processing resume: #{resume.name} (ID: #{resume.id})"
    
    # Prepare the text for embedding
    text_to_embed = prepare_resume_text(resume)
    if text_to_embed.blank?
      puts "Error: No text content found for resume"
      exit 1
    end
    
    puts "Text to embed: #{text_to_embed[0..100]}..."
    
    begin
      # Generate embedding using OpenAI
      embedding = generate_openai_embedding(text_to_embed, openai_api_key)
      
      if embedding.nil?
        puts "Error: Failed to generate embedding"
        exit 1
      end
      
      puts "Successfully generated embedding vector with #{embedding.length} dimensions"
      
      # Save embedding to Elasticsearch
      save_embedding_to_elasticsearch(resume, embedding)
      
      puts "Successfully saved embedding to Elasticsearch"
      
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
      exit 1
    end
  end
  
  desc "Generate embeddings for all resumes"
  task generate_all_embeddings: :environment do
    # Check if OpenAI API key is set
    openai_api_key = ENV['OPENAI_API_KEY']
    if openai_api_key.blank?
      puts "Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set it with: export OPENAI_API_KEY='your-api-key-here'"
      exit 1
    end
    
    resumes = Resume.all
    total_resumes = resumes.count
    
    puts "Starting to generate embeddings for #{total_resumes} resumes..."
    
    resumes.each_with_index do |resume, index|
      puts "Processing #{index + 1}/#{total_resumes}: #{resume.name} (ID: #{resume.id})"
      
      begin
        # Prepare the text for embedding
        text_to_embed = prepare_resume_text(resume)
        next if text_to_embed.blank?
        
        # Generate embedding using OpenAI
        embedding = generate_openai_embedding(text_to_embed, openai_api_key)
        next if embedding.nil?
        
        # Save embedding to Elasticsearch
        save_embedding_to_elasticsearch(resume, embedding)
        
        puts "  ✓ Successfully processed resume #{resume.id}"
        
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
    
    # Check if OpenAI API key is set
    openai_api_key = ENV['OPENAI_API_KEY']
    if openai_api_key.blank?
      puts "Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set it with: export OPENAI_API_KEY='your-api-key-here'"
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
        # Prepare the text for embedding
        text_to_embed = prepare_resume_text(resume)
        next if text_to_embed.blank?
        
        # Generate embedding using OpenAI
        embedding = generate_openai_embedding(text_to_embed, openai_api_key)
        next if embedding.nil?
        
        # Save embedding to Elasticsearch
        save_embedding_to_elasticsearch(resume, embedding)
        
        puts "  ✓ Successfully processed resume #{resume.id}"
        
        # Add a small delay to avoid rate limiting
        sleep(0.1)
        
      rescue => e
        puts "  ✗ Error processing resume #{resume.id}: #{e.message}"
        next
      end
    end
    
    puts "Completed processing #{total_resumes} resumes with status: #{status.upcase}"
  end
  
  private
  
  def prepare_resume_text(resume)
    # Combine relevant fields for embedding
    text_parts = []
    
    text_parts << "Resume Qualification: #{resume.qualification}" if resume.qualification.present?
    text_parts << "Resume Skills: #{resume.skills}" if resume.skills.present?
    text_parts << "Resume Summary: #{resume.summary}" if resume.summary.present?
    
    # Add resume text content (the main content)
    if resume.resume_text_content.present?
      # Truncate if too long to avoid token limits
      content = resume.resume_text_content.length > 4000 ? resume.resume_text_content[0..4000] + "..." : resume.resume_text_content
      text_parts << "Resume Content: #{content}"
    end
    
    # Add experience information
    if resume.exp_in_months.present?
      years = (resume.exp_in_months.to_f / 12).round(1)
      text_parts << "Resume Experience: #{years} years (#{resume.exp_in_months} months)"
    end
   # Join all parts with spaces and clean up
    text_parts.compact.join(" ").strip
  end
  
  def generate_openai_embedding(text, api_key)
    require 'openai'
    
    client = OpenAI::Client.new(api_key: api_key)
    
    response = client.embeddings.create(
      model: "text-embedding-3-small",
      input: text,
      encoding_format: "float"
    )

    puts "Response: #{response.inspect}"
    return response[:data][0][:embedding]
    
  rescue => e
    puts "Error calling OpenAI API: #{e.message}"
    return nil
  end
  
  def save_embedding_to_elasticsearch(resume, embedding)
    # Get the Searchkick index for resumes
    index_name = "recruitment_app_#{Rails.env}_resumes"
    
    # Create or update the document in Elasticsearch
    Searchkick.client.index(
      index: index_name,
      id: resume.id,
      body: {
        doc: {
          embedding: embedding,
          updated_at: Time.current
        },
        doc_as_upsert: true
      }
    )
  end
end
