namespace :test do
  desc "Test OpenAI gem connection and parameters"
  task openai: :environment do
    puts "Testing OpenAI gem connection..."
    
    # Check if OpenAI API key is set
    openai_api_key = ENV['OPENAI_API_KEY']
    if openai_api_key.blank?
      puts "Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set it with: export OPENAI_API_KEY='your-api-key-here'"
      exit 1
    end
    
    puts "OpenAI API key found: #{openai_api_key[0..10]}..."
    
    begin
      require 'openai'
      puts "✓ OpenAI gem loaded successfully"
      
      # Try different ways to initialize the client
      puts "\nTesting client initialization methods..."
      
      # Method 1: Direct parameter
      begin
        client1 = OpenAI::Client.new(openai_api_key)
        puts "✓ Method 1: OpenAI::Client.new(api_key) - SUCCESS"
      rescue => e
        puts "✗ Method 1: OpenAI::Client.new(api_key) - FAILED: #{e.message}"
      end
      
      # Method 2: Hash with api_key
      begin
        client2 = OpenAI::Client.new(api_key: openai_api_key)
        puts "✓ Method 2: OpenAI::Client.new(api_key: api_key) - SUCCESS"
      rescue => e
        puts "✗ Method 2: OpenAI::Client.new(api_key: api_key) - FAILED: #{e.message}"
      end
      
      # Method 3: Hash with access_token
      begin
        client3 = OpenAI::Client.new(access_token: openai_api_key)
        puts "✓ Method 3: OpenAI::Client.new(access_token: api_key) - SUCCESS"
      rescue => e
        puts "✗ Method 3: OpenAI::Client.new(access_token: api_key) - FAILED: #{e.message}"
      end
      
      # Method 4: Hash with token
      begin
        client4 = OpenAI::Client.new(token: openai_api_key)
        puts "✓ Method 4: OpenAI::Client.new(token: api_key) - SUCCESS"
      rescue => e
        puts "✗ Method 4: OpenAI::Client.new(token: api_key) - FAILED: #{e.message}"
      end
      
      # Test embeddings call with the working client
      puts "\nTesting embeddings API call..."
      working_client = nil
      
      [client1, client2, client3, client4].each do |client|
        if client
          working_client = client
          break
        end
      end
      
      if working_client
        puts "Using working client to test embeddings..."
        
        # Debug: Show available methods
        puts "\nAvailable methods on client:"
        methods = working_client.methods - Object.methods
        embedding_methods = methods.select { |m| m.to_s.include?('embed') }
        puts "Embedding-related methods: #{embedding_methods.join(', ')}"
        
        # Test the correct method for openai gem version 0.19.0+
        response = nil
        
        # Primary method: create_embeddings
        begin
          response = working_client.create_embeddings(
            model: "text-embedding-ada-002",
            input: "Hello, world!"
          )
          puts "✓ create_embeddings called successfully!"
        rescue => e
          puts "✗ create_embeddings failed: #{e.message}"
          
          # Fallback to embeddings method
          begin
            response = working_client.embeddings(
              model: "text-embedding-ada-002",
              input: "Hello, world!"
            )
            puts "✓ embeddings method worked as fallback!"
          rescue => e2
            puts "✗ embeddings fallback also failed: #{e2.message}"
          end
        end
        
        if response
          puts "✓ Embeddings API call successful!"
          puts "Response keys: #{response.keys.join(', ')}"
          if response["data"] && response["data"][0] && response["data"][0]["embedding"]
            puts "✓ Embedding vector generated with #{response["data"][0]["embedding"].length} dimensions"
          else
            puts "✗ Unexpected response format"
            puts "Response: #{response.inspect}"
          end
        else
          puts "✗ All embedding API call methods failed"
        end
      else
        puts "✗ No working client found"
      end
      
    rescue => e
      puts "✗ Error loading OpenAI gem: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end
end
