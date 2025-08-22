namespace :requirements do
  desc "Generate embedding vector for a requirement description and save to Elasticsearch"
  task :generate_embedding, [:requirement_id] => :environment do |task, args|
    requirement_id = args[:requirement_id]
    
    if requirement_id.blank?
      puts "Usage: rake requirements:generate_embedding[REQUIREMENT_ID]"
      puts "Example: rake requirements:generate_embedding[123]"
      exit 1
    end
    
    # Check if OpenAI API key is set
    openai_api_key = ENV['OPENAI_API_KEY']
    if openai_api_key.blank?
      puts "Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set it with: export OPENAI_API_KEY='your-api-key-here'"
      exit 1
    end
    
    # Find the requirement
    requirement = Requirement.find_by(id: requirement_id)
    if requirement.nil?
      puts "Error: Requirement with ID #{requirement_id} not found"
      exit 1
    end
    
    puts "Processing requirement: #{requirement.name} (ID: #{requirement.id})"
    
    # Prepare the text for embedding
    text_to_embed = prepare_requirement_text(requirement)
    if text_to_embed.blank?
      puts "Error: No text content found for requirement"
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
      save_embedding_to_elasticsearch(requirement, embedding)
      
      puts "Successfully saved embedding to Elasticsearch"
      
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
      exit 1
    end
  end
  
  desc "Generate embeddings for all requirements"
  task generate_all_embeddings: :environment do
    # Check if OpenAI API key is set
    openai_api_key = ENV['OPENAI_API_KEY']
    if openai_api_key.blank?
      puts "Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set it with: export OPENAI_API_KEY='your-api-key-here'"
      exit 1
    end
    
    requirements = Requirement.all
    total_requirements = requirements.count
    
    puts "Starting to generate embeddings for #{total_requirements} requirements..."
    
    requirements.each_with_index do |requirement, index|
      puts "Processing #{index + 1}/#{total_requirements}: #{requirement.name} (ID: #{requirement.id})"
      
      begin
        # Prepare the text for embedding
        text_to_embed = prepare_requirement_text(requirement)
        next if text_to_embed.blank?
        
        # Generate embedding using OpenAI
        embedding = generate_openai_embedding(text_to_embed, openai_api_key)
        next if embedding.nil?
        
        # Save embedding to Elasticsearch
        save_embedding_to_elasticsearch(requirement, embedding)
        
        puts "  ✓ Successfully processed requirement #{requirement.id}"
        
        # Add a small delay to avoid rate limiting
        sleep(0.1)
        
      rescue => e
        puts "  ✗ Error processing requirement #{requirement.id}: #{e.message}"
        next
      end
    end
    
    puts "Completed processing #{total_requirements} requirements"
  end
  
  private
  
  def prepare_requirement_text(requirement)
    # Combine relevant fields for embedding
    text_parts = []
    
    text_parts << "Requirement Name: #{requirement.name}" if requirement.name.present?
    text_parts << "Requirement Description: #{requirement.description}" if requirement.description.present?
    text_parts << "Requirement Skills: #{requirement.skill}" if requirement.skill.present?
    text_parts << "Requirement Experience: #{requirement.exp.split('-').first} years to #{requirement.exp.split('-').last} years" if requirement.exp.present?
    
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
    
  end
  
  def save_embedding_to_elasticsearch(requirement, embedding)
    # Get the Searchkick index for requirements
    index_name = "recruitment_app_#{Rails.env}_requirements"
    
    # Create or update the document in Elasticsearch
    Searchkick.client.index(
      index: index_name,
      id: requirement.id,
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
