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
    multiple_matches_count = 0
    
    feedbacks_without_interview.find_each do |feedback|
      begin
        # Find interviews for this resume
        resume = feedback.resume
        interviews = Interview.joins(:req_match).where(req_matches: { resume_id: resume.id })
        
        # Find interviews with the same employee (interviewer)
        matching_interviews = interviews.where(employee_id: feedback.employee_id)
        
        if matching_interviews.count == 0
          puts "No matching interview found for feedback #{feedback.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
          
          # Find req_matches for this resume
          req_matches = ReqMatch.where(resume_id: resume.id)
          
          if req_matches.count > 0
            # Find the req_match closest to feedback creation date
            feedback_date = feedback.created_at.to_date
            closest_req_match = req_matches.min_by do |req_match|
              # Use created_at date of req_match as proxy for when the match was made
              (req_match.created_at.to_date - feedback_date).abs
            end
            
            puts "  - Found #{req_matches.count} req_matches, using closest one (ID: #{closest_req_match.id})"
            
            # Create a new interview for this req_match
            new_interview = Interview.new(
              req_match_id: closest_req_match.id,
              employee_id: feedback.employee_id,
              interview_date: feedback.created_at.to_date,
              interview_time: feedback.created_at.to_time,
              created_at: feedback.created_at,
              updated_at: feedback.created_at
            )
            
            if debug_mode
              puts "  [DEBUG] Would create interview for req_match #{closest_req_match.id} with employee #{feedback.employee.name}"
              puts "  [DEBUG] Would associate feedback #{feedback.id} with the new interview"
            else
              # Save the new interview
              new_interview.save!
              puts "  - Created new interview #{new_interview.id} for req_match #{closest_req_match.id}"
              
              # Associate the feedback with the new interview
              feedback.update!(interview_id: new_interview.id)
              puts "  - Associated feedback #{feedback.id} with new interview #{new_interview.id}"
            end
            associated_count += 1
          else
            puts "  - No req_matches found for resume #{resume.id}, skipping feedback"
            skipped_count += 1
          end
        elsif matching_interviews.count == 1
          # Single match - proceed normally
          matching_interview = matching_interviews.first
          
          if debug_mode
            puts "[DEBUG] Would associate feedback #{feedback.id} with interview #{matching_interview.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
          else
            # Associate the feedback with the interview
            feedback.update!(interview_id: matching_interview.id)
            puts "Associated feedback #{feedback.id} with interview #{matching_interview.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
          end
          associated_count += 1
        else
          # Multiple matches - need to choose one
          multiple_matches_count += 1
          puts "Multiple matching interviews found for feedback #{feedback.id} (Employee: #{feedback.employee.name}, Resume: #{resume.name})"
          
          # Strategy 2: Choose the interview closest to feedback creation date
          feedback_date = feedback.created_at.to_date
          closest_date_interview = matching_interviews.min_by do |interview|
            (interview.interview_date - feedback_date).abs
          end
          
          # Use Strategy 2: closest date to feedback creation
          selected_interview = closest_date_interview
          
          puts "  - Found #{matching_interviews.count} interviews:"
          matching_interviews.each do |interview|
            days_diff = (interview.interview_date - feedback_date).abs
            puts "    * Interview #{interview.id}: #{interview.interview_date} at #{interview.interview_time} (days from feedback: #{days_diff})"
          end
          puts "  - Selected interview #{selected_interview.id} (closest date to feedback creation)"
          
          if debug_mode
            puts "  [DEBUG] Would associate feedback #{feedback.id} with interview #{selected_interview.id}"
          else
            # Associate the feedback with the selected interview
            feedback.update!(interview_id: selected_interview.id)
            puts "  - Associated feedback #{feedback.id} with interview #{selected_interview.id}"
          end
          associated_count += 1
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
      puts "[DEBUG MODE] Multiple matches found: #{multiple_matches_count}"
    else
      puts "Total feedbacks processed: #{total_feedbacks}"
      puts "Successfully associated: #{associated_count}"
      puts "Skipped: #{skipped_count}"
      puts "Multiple matches handled: #{multiple_matches_count}"
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
    
    # Show multiple matches analysis
    puts "\n=== Multiple Matches Analysis ==="
    feedbacks_without_interview = Feedback.where(interview_id: nil)
    multiple_matches_count = 0
    
    feedbacks_without_interview.each do |feedback|
      resume = feedback.resume
      interviews = Interview.joins(:req_match).where(req_matches: { resume_id: resume.id })
      matching_interviews = interviews.where(employee_id: feedback.employee_id)
      
      if matching_interviews.count > 1
        multiple_matches_count += 1
        puts "Feedback #{feedback.id} has #{matching_interviews.count} matching interviews"
      end
    end
    
    puts "Feedbacks with multiple matching interviews: #{multiple_matches_count}"
  end
end 