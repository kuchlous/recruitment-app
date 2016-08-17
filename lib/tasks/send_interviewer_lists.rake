desc 'Send list of interviewers who completed 25 mark'
task :send_interviewer_lists do |t, env|
  Rake::Task["environment"].invoke
  all_considered_feedbacks = Feedback.all(:conditions => ["created_at > ?", Date.new(2014, 1, 1) ] )
  interviewers = {}
  all_considered_feedbacks.each do |f|
    interviewers[f.employee] ||= []
    interviewers[f.employee] << f
  end
  interviewer_interview_pairs = []
  interviewers.each do |e, feedbacks|
    interviewer_interview_pairs << [e, feedbacks]
  end
  selected_interviewers = []
  interviewer_interview_pairs.each do |pair|
    interviews = pair[1]
    cnt_today = 0
    interviews.each do |i|
     cnt_today += 1 if i.created_at.to_date == Date.today
    end
    cnt_till_yesterday = interviews.size - cnt_today
    selected_interviewers << pair if (interviews.size / 25 != cnt_till_yesterday / 25)
  end
  gm_hash = {}
  selected_interviewers.each do |pair|
    gm = pair[0].gm
    if gm
      gm_hash[gm] ||= []
      gm_hash[gm] << pair
    end
  end
  Emailer.deliver_interviewer_list(Employee.get_finance_employee, selected_interviewers)
  Emailer.deliver_interviewer_list(Employee.get_HR_employee, selected_interviewers)
  gm_hash.each do |gm, pairs|
    Emailer.deliver_interviewer_list(alok, pairs)
  end
end
