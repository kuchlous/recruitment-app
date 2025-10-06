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

    def generate_resume_summary(resume_text, name = nil, skills = nil, experience = nil)
      api_key = ENV['OPENAI_API_KEY']
      if api_key.blank?
        raise "OPENAI_API_KEY environment variable is not set"
      end

      client = OpenAI::Client.new(api_key: api_key)

      # Prepare the prompt for summary generation
      prompt = build_summary_prompt(resume_text, name, skills, experience)

      begin
        response = client.chat.completions.create(
          model: "gpt-3.5-turbo",
          messages: [
            {
              role: "system",
              content: "You are an expert HR professional who creates concise, professional resume summaries. Focus on highlighting key experience, skills, and qualifications in about 100 words."
            },
            {
              role: "user",
              content: prompt
            }
          ],
          max_tokens: 150,
          temperature: 0.3
        )

        summary = response.dig("choices", 0, "message", "content")&.strip
        return summary if summary.present?
        
        Rails.logger.error "OpenAI returned empty summary for resume"
        return nil
      rescue => e
        Rails.logger.error "Error generating resume summary: #{e.message}"
        return nil
      end
    end

    private

    def build_summary_prompt(resume_text, name, skills, experience)
      prompt_parts = []
      
      if name.present?
        prompt_parts << "Candidate Name: #{name}"
      end
      
      if experience.present?
        prompt_parts << "Experience: #{experience}"
      end
      
      if skills.present?
        prompt_parts << "Skills: #{skills}"
      end
      
      prompt_parts << "Resume Content:"
      prompt_parts << resume_text
      
      prompt_parts.join("\n\n")
    end
  end
end
