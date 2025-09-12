class Emailer < ApplicationMailer

  # Send email when adding message
  def add_message(mesg, log_employee)
    subject =   "From: #{mesg.sent_by.name}, Resume: #{mesg.resume.name}"
    recipients =   [ mesg.sent_to.email ]
    @emp_from = mesg.sent_by
    @emp_to = mesg.sent_to
    @mesg = mesg
    mail(to: recipients, subject: subject)
  end

  def upload(resume, mail_to)
    subject = 'Referral of ' + resume.name 
    recipients = [ mail_to.email ]

    @to_employee = mail_to
    @resume = resume
    mail(to: recipients, subject: subject)
  end

  def joined(resume, mail_to, status)
    subject = 'Referral ' + status
    recipients = [ mail_to.email ]
    recipients << resume.ta_owner.email if resume.ta_owner.present?

    @to_employee    = mail_to
    @resume         = resume
    @status         = status
    mail(to: recipients, subject: subject)
  end

  def forward(logged_emp,  mail_to, resume, file_name)
    subject = 'Resume received'
    recipients = [ mail_to.email ]

    @to_employee    = mail_to
    @from_employee  = logged_emp
    @resume         = resume
    @file_name      = file_name
    mail(to: recipients, subject: subject)
  end

  def notify_ta_owner(ta_owner, logged_emp, resume, is_new = false)
    subject = is_new ? 'New Resume Uploaded' : 'Resume Updated'
    @ta_owner    = ta_owner
    @logged_emp  = logged_emp
    @resume         = resume
    @email_body = is_new ? "Resume of '#{resume.name}' has been uploaded by #{logged_emp.name}." : "Resume of '#{resume.name}' has been updated by #{logged_emp.name}."

    mail(to: ta_owner.email, subject: subject)
  end

  def interview_confirmation(interview)
    @interview = interview
    @candidate = interview.resume
    @ta_owner = interview.resume.ta_owner
    @requirement = interview.requirement
    
    # Format date as DD/MM/YY
    @formatted_date = interview.interview_date.strftime("%d/%m/%y")
    @formatted_time = interview.interview_time.strftime("%I:%M %p")
    
    # Determine subject and mode based on interview type
    if interview.itype == "TELEPHONIC"
      subject = "Interview confirmation | #{@candidate.name} - Mirafra Technologies"
      @mode = "MS Teams (VCON/TCON) OR Telephonic"
      @is_telephonic = true
    else
      subject = "F2F Interview confirmation | #{@candidate.name} - Mirafra Technologies"
      @mode = "Face to Face"
      @is_telephonic = false
    end

    mail(to: ["ridhima@mirafra.com", "alokk@mirafra.com"], subject: subject)
    # mail(to: [@candidate.email, @ta_owner.email], subject: subject)
  end

  def hwe_interviewer_notification(interview)
    @interview = interview
    @candidate = interview.resume
    @ta_owner = interview.resume.ta_owner
    @requirement = interview.requirement
    @interviewer = interview.employee
    
    # Format date as DD/MM/YY
    @formatted_date = interview.interview_date.strftime("%d/%m/%y")
    @formatted_time = interview.interview_time.strftime("%I:%M %p")
    
    # Determine subject and mode based on interview type
    if interview.itype == "TELEPHONIC"
      subject = "Interview Scheduled | #{@candidate.name} - Mirafra Technologies"
      @mode = "MS Teams (VCON/TCON) OR Telephonic"
      @is_telephonic = true
    else
      subject = "F2F Interview Scheduled | #{@candidate.name} - Mirafra Technologies"
      @mode = "Face to Face"
      @is_telephonic = false
    end

    mail(to: @interviewer.email, subject: subject)
  end

  def panel(mail_to, interview, resume)
    subject = 'Added to interview panel'
    recipients = [ mail_to.email ]
    recipients << resume.ta_owner.email if resume.ta_owner.present?
    fname = resume.uniqid.name
    @to_employee  = mail_to
    @resume       = resume
    @uniqid       = resume.uniqid
    @requirement  = interview.req_match.requirement
    @interview    = interview
    # Sending .ics file as an attachment
    ics_file = create_ics_file(fname, interview)
    attachments[fname   + ".ics"] = File.read(ics_file)
    mail(to: recipients, subject: subject)
    ics_file.unlink
  end

  def create_ics_file(fname, interview)
    ics_file =  Tempfile.new(fname)
    ics_file.puts 'BEGIN:VCALENDAR'
    ics_file.puts 'VERSION:1.0'
    ics_file.puts 'BEGIN:VEVENT'
    ics_file.puts 'CATEGORIES:MEETING'
    ics_file.puts "STATUS:#{interview.status}"

    # Finding start and end times
    # Decreasing 5 and half hours to make it compatible with indian time
    # 60*60*5 + 1800 (Not sure this is good idea)
    original_interview_time   = interview.interview_time
    iso8601_start_format_time = original_interview_time - 19_800
    iso8601_start_format_time = iso8601_start_format_time.iso8601.dup
    iso8601_end_format_time   = original_interview_time - 19_800 + 3600 # Added 3600 seconds to extend time to two hours :). Will find a better idea over this weekend probably
    iso8601_end_format_time   = iso8601_end_format_time.iso8601.dup
    # Start Time
    iso8601_start_format_time.gsub!('2000-01-01', interview.interview_date.to_s)
    iso8601_start_format_time.gsub!(/[:-]/, '')
    # End Time
    iso8601_end_format_time.gsub!('2000-01-01', interview.interview_date.to_s)
    iso8601_end_format_time.gsub!(/[:-]/, '')

    ics_file.puts "DTSTART:#{iso8601_start_format_time}"
    ics_file.puts "DTEND:#{iso8601_end_format_time}"
    ics_file.puts "SUMMARY: STAGE- #{interview.stage}, INTERVIEW TYPE- #{interview.itype}"
    ics_file.puts "DESCRIPTION: FOCUS- #{interview.focus}"
    ics_file.puts 'CLASS:PRIVATE'
    ics_file.puts 'BEGIN:VALARM'
    ics_file.puts 'TRIGGER:-PT15M'
    ics_file.puts 'ACTION:DISPLAY'
    ics_file.puts 'DESCRIPTION: Reminder'
    ics_file.puts 'END:VALARM'
    ics_file.puts 'END:VEVENT'
    ics_file.puts 'END:VCALENDAR'
    ics_file.close
    return ics_file
  end

  def action(logged_emp, resume, req_name, status, comment)
    subject =        'Resume ' + status.downcase
    recipients = [ resume.employee.current_email ]
    recipients << resume.ta_owner.email if resume.ta_owner.present?
    @from_employee = logged_emp
    @resume        = resume
    @req_name      = req_name
    @uniqid        = resume.uniqid
    @status        = status
    mail(to: recipients, subject: subject)
  end

  def feedback(logged_emp, resume, req, feedback)
    subject =        'Feedback received'
    recipients = [ resume.employee.current_email, req.employee.current_email ] 
    recipients << resume.ta_owner.email if resume.ta_owner.present?
    @from_employee = logged_emp
    @feedback      = feedback
    @resume        = resume
    @req           = req
    mail(to: recipients, subject: subject)
  end

  def requirement(cur_emp, req, is_create = 1)
    subject = 'Requirement Added'
    recipients = [ req.employee.current_email ]
    @cur_emp = cur_emp
    @req = req
    @is_create = is_create
    mail(to: recipients, subject: subject)
  end

  def reminder(employee, interviews)
    subject = 'Interviews scheduled for today'
    recipients = [ employee.email ]
    @interviews = interviews
    @employee = employee
    mail(to: recipients, subject: subject)
  end

  def interviewer_list(employee, interviewer_pairs)
    subject = 'Employees completing 25 today'
    recipients = [ employee.email ]
    @interviewer_pairs   = interviewer_pairs
    @employee = employee
    mail(to: recipients, subject: subject)
  end

  # Will notify manager if panel is added for his requirement
  def notify_manager_for_panel(emp_from, req, resume, emp_to, emp_array)
    subject = 'Interview added for your requirement'
    recipients = [ emp_to.email ]
    @emp_from = emp_from
    @emp_to = emp_to
    @emp_array = emp_array
    @req = req
    @resume = resume
    mail(to: recipients, subject: subject)
  end
  # Send email when decline interview request
  def decline(emp_from, emp_to, interview)
    subject = "Interview declined"
    recipients = [ emp_to.email ]
    @emp_from = emp_from
    @emp_to = emp_to
    @interview = interview
    mail(to: recipients, subject: subject)
  end

  # Send email when interview got cancelled
  def removed_panel(interview, resume)
    subject = "Interview cancelled"
    recipients = [ interview.employee.email ]
    recipients << resume.ta_owner.email if resume.ta_owner.present?
    @emp_to = interview.employee
    @interview = interview
    @uniqid = resume.uniqid
    @resume = resume
    @requirement = interview.req_match.requirement
    mail(to: recipients, subject: subject)
  end

  def send_for_decision(resume, requirement, to, rattachment, filetype, ext, recipients, eng_decision, hire_action)
    decision_string = eng_decision ? "Eng" : "Management"
    subject = decision_string +  " decision for #{resume.name}, " + "Requirement: " + requirement.name
    recipients = recipients.map{|r| r.email }
    attachments[resume.uniqid.name + "." + ext] = File.read(rattachment)
    @resume = resume
    @to = to
    @requirement = requirement
    @hire_action = hire_action
    @eng_decision = eng_decision
    mail(to: recipients.uniq, subject: subject)
  end

  def send_for_status_change(resume, requirement, recipients, status, comment)
    subject = "FYI: " + status +  ", #{resume.name}, " + "Requirement: " + requirement.name
    recipients = recipients.map{|r| r.email }
    recipients << resume.ta_owner.email if resume.ta_owner.present?
    @resume = resume
    @requirement = requirement
    @status = status
    @comment = comment
    mail(to: recipients, subject: subject)
  end

  def send_for_probation_decision (employee)
    @employee_name=employee.name
    @employee_eid=employee.eid
    @employee_email=employee.email
    subject="For your action: Probation closure of your team member - #{employee.name}" 
    attachments["Probationer's Performance Evaluation.doc"] = 
      File.read(Rails.root.join("lib/tasks/probationer-perf-eval.doc"))
    mail(from: "hr-no-reply@mirafra.com", to: [employee.manager.email, "probation@mirafra.com"], subject: subject)
  end
  
  def send_requirement_reminder (requirement)
    @names = []
    # Add all TA leads from HABTM association
    requirement.ta_leads.each do |lead|
      @names << lead.name
    end
    # Add all engineering leads from HABTM association
    requirement.eng_leads.each do |lead|
      @names << lead.name
    end
    @names = @names.join(", ")
    recipients = []
    # Add all TA leads emails from HABTM association
    requirement.ta_leads.each do |lead|
      recipients << lead.email
    end
    # Add all engineering leads emails from HABTM association
    requirement.eng_leads.each do |lead|
      recipients << lead.email
    end
    # TODO: Add Sales Head to recipients
    subject = "Gentle Reminder - Requirement open with No projection for more than 3 days"
    mail(to: recipients, subject: subject) if recipients.length > 0
  end

  def send_rejection_notification (requirement,resume)
    @names = []
    # Add all TA leads from HABTM association
    requirement.ta_leads.each do |lead|
      @names << lead.name
    end
    # Add all engineering leads from HABTM association
    requirement.eng_leads.each do |lead|
      @names << lead.name
    end
    @names = @names.join(", ")
    recipients = []
    # Add all TA leads emails from HABTM association
    requirement.ta_leads.each do |lead|
      recipients << lead.email
    end
    # Add all engineering leads emails from HABTM association
    requirement.eng_leads.each do |lead|
      recipients << lead.email
    end
    recipients << resume.ta_owner.email if resume.ta_owner.present?
    # TODO: Add Sales Head to recipients
    subject = "#{resume.name} is rejected for #{requirement.name}"
    mail(to: recipients, subject: subject) if recipients.length > 0
  end

  # Weekly summary mail to TA lead listing requirements pending review
  def weekly_ta_requirement_summary(ta_lead, requirements)
    @ta_lead = ta_lead
    @requirements = requirements
    subject = "Weekly Pending Requirement Review Summary"
    mail(to: ta_lead.email, subject: subject)
  end

  def feedback_reminder(interview)
    @panel_member = interview.employee
    @interview = interview
    @requirement = interview.req_match.requirement
    @resume = interview.req_match.resume
    subject = "Reminder to provide feedback for the interview conducted on #{@interview.interview_date}"
    mail(to: @panel_member.email, subject: subject)
  end
end

