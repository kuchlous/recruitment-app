namespace :feedbacks do
  desc "Associate existing feedbacks with interviews based on employee and resume"
  task associate_with_interviews: :environment do
    # Check for debug flag
    debug_mode = ENV['DEBUG'] == 'true'
    
    if debug_mode
      puts "=== DEBUG MODE - No actual updates will be made ==="
    end
    
    puts "Starting to associate feedbacks with interviews..."
    
    # Get all feedbacks that don't have an interview_id
    feedbacks_without_interview = Feedback.where(interview_id: nil)
    total_feedbacks = feedbacks_without_interview.count
    
    puts "Found #{total_feedbacks} feedbacks without interview association"
    
    associated_count = 0
    skipped_count = 0
    
    feedbacks_without_interview.find_each do |feedback|
      begin
        # Find interviews for this resume
        resume = feedback.resume
        interviews = Interview.joins(:req_match).where(req_matches: { resume_id: resume.id })
        
        # Find interview with the same employee (interviewer)
        matching_interview = interviews.find_by(employee_id: feedback.employee_id)
        
        if matching_interview
          # Check if this interview already has feedback
          if matching_interview.feedback.present?
            puts "Skipping feedback #{feedback.id} - interview #{matching_interview.id} already has feedback"
            skipped_count += 1
          else
            if debug_mode
              puts "[DEBUG] Would associate feedback #{feedback.id} with interview #{matching_interview.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
            else
              # Associate the feedback with the interview
              feedback.update!(interview_id: matching_interview.id)
              puts "Associated feedback #{feedback.id} with interview #{matching_interview.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
            end
            associated_count += 1
          end
        else
          puts "No matching interview found for feedback #{feedback.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
          skipped_count += 1
        end
        
      rescue => e
        puts "Error processing feedback #{feedback.id}: #{e.message}"
        skipped_count += 1
      end
    end
    
    puts "\n=== Summary ==="
    if debug_mode
      puts "[DEBUG MODE] Would have processed: #{total_feedbacks} feedbacks"
      puts "[DEBUG MODE] Would have associated: #{associated_count}"
      puts "[DEBUG MODE] Would have skipped: #{skipped_count}"
    else
      puts "Total feedbacks processed: #{total_feedbacks}"
      puts "Successfully associated: #{associated_count}"
      puts "Skipped: #{skipped_count}"
      puts "Remaining feedbacks without interview: #{Feedback.where(interview_id: nil).count}"
    end
  end
  
  desc "Show statistics about feedback-interview associations"
  task stats: :environment do
    total_feedbacks = Feedback.count
    feedbacks_with_interview = Feedback.where.not(interview_id: nil).count
    feedbacks_without_interview = Feedback.where(interview_id: nil).count
    
    puts "=== Feedback-Interview Association Statistics ==="
    puts "Total feedbacks: #{total_feedbacks}"
    puts "Feedbacks with interview: #{feedbacks_with_interview}"
    puts "Feedbacks without interview: #{feedbacks_without_interview}"
    puts "Association rate: #{(feedbacks_with_interview.to_f / total_feedbacks * 100).round(2)}%"
    
    # Show some examples of unassociated feedbacks
    if feedbacks_without_interview > 0
      puts "\n=== Sample unassociated feedbacks ==="
      Feedback.where(interview_id: nil).limit(5).each do |feedback|
        puts "Feedback #{feedback.id}: #{feedback.employee.name} -> #{feedback.resume.name} (#{feedback.rating})"
      end
    end
  end
end 