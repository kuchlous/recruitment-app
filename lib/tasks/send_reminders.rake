desc 'Send Reminders for todays interviews'
task :send_reminders do |t, env|
  Rake::Task["environment"].invoke
  # Send a remainder to people who have to take interviews in the same or coming day.
  all_interviews_today_tommorow = Interview.all(:conditions => ["interview_date = ?", Date.today ] )
  e_interviews = {}
  all_interviews_today_tommorow.each do |interview|
    e_interviews[interview.employee] ||= [] 
    e_interviews[interview.employee] << interview
  end
  e_interviews.each do |e, interviews|
    interviews.sort! { |a, b| a.interview_time <=> b.interview_time }
    Emailer.deliver_reminder(e, interviews)
  end
end
