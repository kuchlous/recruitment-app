class Emailer < ApplicationMailer

  # Send email when adding message
  def add_message(mesg, log_employee)
    subject =   "From: #{mesg.sent_by.name}, Resume: #{mesg.resume.name}"
    recipients =   [ mesg.sent_to.email ]
    from =    [ log_employee.email ]
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

  def panel(mail_to, interview, resume)
    subject =        'Added to interview panel'
    recipients = [ mail_to.email ]

    @to_employee  = mail_to
    @resume       = resume
    @uniqid       = resume.uniqid
    @requirement  = interview.req_match.requirement
    @interview    = interview
    # Sending .ics file as an attachment
    attachments[resume.uniqid.name   + ".ics"] = File.read(Rails.root + "/tmp/" + "#{resume.uniqid.name}")
    mail(to: recipients, subject: subject)
  end

  def action(logged_emp, resume, req_name, status, comment)
    subject =        'Resume ' + status.downcase
    recipients = [ resume.employee.current_email ]
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
    @emp_to = interview.employee
    @interview = interview
    @uniqid = resume.uniqid
    @resume = resume
    @requirement = interview.req_match.requirement
    mail(to: recipients, subject: subject)
  end

  def send_for_decision(resume, requirement, to, rattachment, filetype, recipients, hire_action)
    subject = "Need Decision for #{resume.name}"
    recipients = recipients.map{|r| r.email }
    attachments[resume.uniqid.name] = File.read(rattachment)
    @resume = resume
    @to = to
    @requirement = requirement
    @hire_action = hire_action
    mail(to: recipients, subject: subject)
  end

  def send_for_probation_decision (employee)
    @employee_name=employee.name
    @employee_eid=employee.eid
    @employee_email=employee.email
    subject="For your action: Probation closure of your team member - #{employee.name}" 
    mail(to: employee.manager.email, subject: subject)
  end  
end

