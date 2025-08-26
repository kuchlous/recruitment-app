require 'openai'

module OpenaiUtils
  class << self
      def generate_embedding(text)
    api_key = ENV['OPENAI_API_KEY']
    if api_key.blank?
      raise "OPENAI_API_KEY environment variable is not set"
    end
    
    client = OpenAI::Client.new(api_key: api_key)
      
      response = client.embeddings.create(
        model: "text-embedding-3-small",
        input: text,
        encoding_format: "float"
      )

      puts "Response: #{response.inspect}"
      return response[:data][0][:embedding]
    end
  end
end
