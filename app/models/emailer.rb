class Emailer < ActionMailer::Base
  $upload_dir    = Rails.root + "/" + APP_CONFIG['upload_directory']
  $temp_dir      = Rails.root + "/" + APP_CONFIG['temp_directory']
  $temp_filename = APP_CONFIG['temp_file']

  def upload(resume, mail_to)
    subject        'Referral of ' + resume.name 
    recipients     [ mail_to.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type  'text/html'

    body           :to_employee    => mail_to,
                   :resume         => resume
  end

  def joined(resume, mail_to, status)
    subject        'Referral ' + status
    recipients     [ mail_to.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type  'text/html'

    body           :to_employee    => mail_to,
                   :resume         => resume,
                   :status         => status
  end

  def forward(logged_emp,  mail_to, resume,
              file_name)
    subject        'Resume received'
    recipients     [ mail_to.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type  'text/html'

    body           :to_employee    => mail_to,
                   :from_employee  => logged_emp,
                   :resume         => resume,
                   :file_name      => file_name
  end

  def panel(mail_to, interview, resume)
    subject        'Added to interview panel'
    recipients     [ mail_to.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type  'text/html'

    body           :to_employee  => mail_to,
                   :resume       => resume,
                   :uniqid       => resume.uniqid,
                   :requirement  => interview.req_match.requirement,
                   :interview    => interview
    # Sending .ics file as an attachment
    attachment "application/octet-stream" do |a|  
      a.body     = File.read(RAILS_ROOT + "/tmp/" + "#{resume.uniqid.name}")
      a.filename = resume.uniqid.name   + ".ics"
    end
  end

  def action(logged_emp, resume,  req_name,
             status,     comment)
    subject        'Resume ' + status.downcase
    recipients     [ resume.employee.current_email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :from_employee => logged_emp,
                   :resume        => resume,
                   :req_name      => req_name,
                   :uniqid        => resume.uniqid,
                   :status        => status
  end

  def feedback(logged_emp, resume, req, feedback)
    subject        'Feedback received'
    recipients     [ resume.employee.current_email, req.employee.current_email ] 
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :from_employee => logged_emp,
                   :feedback      => feedback,
                   :resume        => resume,
                   :req           => req
  end

  def requirement(cur_emp, req, is_create = 1)
    subject        'Requirement Added'
    recipients     [ req.employee.current_email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :cur_emp       => cur_emp,
                   :req           => req,
                   :is_create     => is_create
  end

  def reminder(employee, interviews)
    subject        'Interviews scheduled for today'
    recipients     [ employee.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :interviews   => interviews,
                   :employee => employee
  end

  def interviewer_list(employee, interviewer_pairs)
    subject        'Employees completing 25 today'
    recipients     [ employee.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :interviewer_pairs   => interviewer_pairs,
                   :employee => employee
  end

  # Will notify manager if panel is added for his requirement
  def notify_manager_for_panel(emp_from, req, resume, emp_to, emp_array)
    subject        'Interview added for your requirement'
    recipients     [ emp_to.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :emp_from  => emp_from,
                   :emp_to    => emp_to,
                   :emp_array => emp_array,
                   :req       => req,
                   :resume    => resume
  end

  # Send email when adding message
  def add_message(mesg, log_employee)
    subject        "From: #{mesg.sent_by.name}, Resume: #{mesg.resume.name}"
    recipients     [ mesg.sent_to.email ]
    from           [ log_employee.email ]
    reply_to       [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :emp_from => mesg.sent_by,
                   :emp_to   => mesg.sent_to,
                   :mesg     => mesg
  end

  # Send email when decline interview request
  def decline(emp_from, emp_to, interview)
    subject        "Interview declined"
    recipients     [ emp_to.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :emp_from => emp_from,
                   :emp_to   => emp_to,
                   :interview => interview
  end

  # Send email when interview got cancelled
  def removed_panel(interview, resume)
    subject        "Interview cancelled"
    recipients     [ interview.employee.email ]
    from           [ "recruitment-no-reply@mirafra.com" ]
    sent_on        Time.now
    content_type   'text/html'
    body           :emp_to    => interview.employee,
                   :interview => interview,
                   :uniqid    => resume.uniqid,
                   :resume    => resume,
                   :requirement  => interview.req_match.requirement
  end
end
