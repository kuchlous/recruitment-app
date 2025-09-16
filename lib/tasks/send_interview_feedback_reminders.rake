
# rake interview:reminder_for_feedback 
# Run this daily at 10:00 AM

namespace :interview do
  desc 'Send feedback reminder to panel members for interviews conducted in last 3 days'
  task :reminder_for_feedback => :environment do

    # Get all interviews conducted in last 3 days
    puts Date.today.to_s + ": Started interview:reminder_for_feedback"
    interviews = Interview.where(interview_date: 3.days.ago..Date.today)

    # Send feedback reminder to panel members for each interview
    interviews.each do |interview|
      Emailer.feedback_reminder(interview).deliver_now if interview.feedbacks.empty?
    end
  end
end
