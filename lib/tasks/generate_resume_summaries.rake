namespace :resume do
  desc "Generate AI-powered summaries for resumes using OpenAI (stored in ai_summary field)"
  task :generate_summaries, [:resume_id, :force] => :environment do |task, args|
    # Check if OpenAI API key is configured
    unless ENV['OPENAI_API_KEY'].present?
      puts "❌ Error: OPENAI_API_KEY environment variable is not set"
      puts "Please set your OpenAI API key: export OPENAI_API_KEY='your-api-key-here'"
      exit 1
    end

    puts "🤖 Starting resume summary generation..."
    puts "=" * 50

    # Determine which resumes to process
    if args[:resume_id].present?
      # Process specific resume
      resume_id = args[:resume_id].to_i
      resume = Resume.find_by(id: resume_id)
      
      unless resume
        puts "❌ Error: Resume with ID #{resume_id} not found"
        exit 1
      end
      
      resumes_to_process = [resume]
      puts "📄 Processing specific resume: #{resume.name} (ID: #{resume.id})"
    else
      # Process all resumes that need summaries
      force_update = args[:force] == 'true'
      
      if force_update
        resumes_to_process = Resume.all
        puts "🔄 Processing all resumes (force update mode)"
      else
        resumes_to_process = Resume.where(ai_summary: [nil, ""])
        puts "📋 Processing resumes without AI summaries (#{resumes_to_process.count} found)"
      end
    end

    if resumes_to_process.empty?
      puts "✅ No resumes to process"
      exit 0
    end

    # Process resumes
    success_count = 0
    error_count = 0
    skipped_count = 0

    resumes_to_process.each do |resume|
      begin
        puts "\n📄 Processing: #{resume.name} (ID: #{resume.id})"
        
        # Skip if resume already has an AI summary and not forcing update
        if resume.ai_summary.present? && args[:force] != 'true'
          puts "⏭️  Skipping - already has AI summary"
          skipped_count += 1
          next
        end

        # Check if resume has text content
        unless resume.resume_text_content.present?
          puts "⚠️  Skipping - no text content available"
          skipped_count += 1
          next
        end

        # Prepare data for summary generation
        resume_text = resume.resume_text_content
        candidate_name = resume.name
        skills = resume.skills
        experience = resume.experience

        # Generate summary using OpenAI
        puts "🔄 Generating summary..."
        summary = OpenaiUtils.generate_resume_summary(
          resume_text, 
          candidate_name, 
          skills, 
          experience
        )

        if summary.present?
          # Update resume with generated AI summary
          resume.update!(ai_summary: summary)
          puts "✅ AI summary generated and saved (#{summary.length} characters)"
          puts "📝 AI Summary: #{summary[0..100]}#{'...' if summary.length > 100}"
          success_count += 1
        else
          puts "❌ Failed to generate AI summary"
          error_count += 1
        end

      rescue => e
        puts "❌ Error processing resume #{resume.id}: #{e.message}"
        error_count += 1
      end
    end

    # Print summary
    puts "\n" + "=" * 50
    puts "📊 Summary Generation Complete"
    puts "=" * 50
    puts "✅ Successfully processed: #{success_count} resumes"
    puts "⏭️  Skipped: #{skipped_count} resumes"
    puts "❌ Errors: #{error_count} resumes"
    puts "📄 Total processed: #{success_count + skipped_count + error_count} resumes"
    
    if error_count > 0
      puts "\n⚠️  Some resumes failed to process. Check the logs above for details."
    end
  end

  desc "Generate AI summary for a specific resume by ID"
  task :generate_summary, [:resume_id] => :environment do |task, args|
    if args[:resume_id].blank?
      puts "❌ Error: Please provide a resume ID"
      puts "Usage: rake resume:generate_summary[123]"
      exit 1
    end
    
    Rake::Task["resume:generate_summaries"].invoke(args[:resume_id], false)
  end

  desc "Regenerate AI summaries for all resumes (force update)"
  task :regenerate_all_summaries => :environment do
    puts "🔄 Regenerating summaries for all resumes..."
    Rake::Task["resume:generate_summaries"].invoke(nil, true)
  end

  desc "Show resume AI summary statistics"
  task :summary_stats => :environment do
    total_resumes = Resume.count
    resumes_with_ai_summaries = Resume.where.not(ai_summary: [nil, ""]).count
    resumes_without_ai_summaries = total_resumes - resumes_with_ai_summaries
    
    puts "📊 Resume AI Summary Statistics"
    puts "=" * 35
    puts "Total resumes: #{total_resumes}"
    puts "With AI summaries: #{resumes_with_ai_summaries}"
    puts "Without AI summaries: #{resumes_without_ai_summaries}"
    puts "Coverage: #{(resumes_with_ai_summaries.to_f / total_resumes * 100).round(1)}%"
  end
end
