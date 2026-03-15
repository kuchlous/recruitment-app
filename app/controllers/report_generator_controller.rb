class ReportGeneratorController < ApplicationController
  require 'rubyXL'
  require 'rubyXL/convenience_methods'

  # check_for_login redirects to index for login
  before_action :check_for_login
  before_action :check_for_TA_HEAD, only: [:reports, :export_reports, :pipeline_report, :export_pipeline_report, :interview_reports_per_requirement, :export_interview_reports_per_requirement]
  before_action :check_for_TA_HEAD_or_TA_LEAD, only: [:ta_owner_reports, :export_ta_owner_reports, :interview_reports_ta_owner, :export_interview_reports_ta_owner]
  before_action :set_employee
  before_action :set_date_range, only: [:reports, :export_reports, :ta_owner_reports, :export_ta_owner_reports, :pipeline_report, :export_pipeline_report, :interview_reports_ta_owner, :export_interview_reports_ta_owner, :interview_reports_per_requirement, :export_interview_reports_per_requirement]

  def reports
    @report_data = generate_requirements_report(@start_date, @end_date)
  end

  def export_reports
    report_data = generate_requirements_report(@start_date, @end_date)
    
    headers = [
      'Group Name', 'Requirement Name', 'Total Forward', 'Total Shortlists',
      'Total Interviews (Candidates)', 'Total L1 Completed', 'Total L2 Completed',
      'Total L3 Completed', 'Total YTO', 'Total HAC', 'Total Hold',
      'Total Offered', 'Total Not Accepted', 'Total Joined', 'Total Not Joined',
      'Total Rejects', 'TA Manager'
    ]
    
    data_rows = report_data.map do |row|
      [
        row['group_name'], row['requirement_name'], row['total_forwards'], row['total_shortlists'],
        row['total_interviews'], row['total_l1_completed'], row['total_l2_completed'],
        row['total_l3_completed'], row['total_yto'], row['total_hac'], row['total_hold'],
        row['total_offered'], row['total_not_accepted'], row['total_joined'], 
        row['total_not_joined'], row['total_rejects'], row['ta_manager_name']
      ]
    end

    generate_and_send_excel("Reports", headers, data_rows)
  end

  def ta_owner_reports
    @report_data = generate_ta_owner_report(@start_date, @end_date, @employee)
  end

  def export_ta_owner_reports
    report_data = generate_ta_owner_report(@start_date, @end_date, @employee)
    
    headers = [
      'TA Owner', 'Forward Date', 'Candidate Name', 'Requirement Name', 'TA Leads', 'Skills',
      'Company Name', 'Total Experience', 'Current CTC', 'Expected CTC', 'Notice Period',
      'Serving Notice Period (Yes/No)', 'LWD', 'Current Location', 'Preferred Location', 'Link'
    ]

    data_rows = report_data.map do |row|
      resume_url = "#{APP_CONFIG['host_name']}/resumes/show/#{row['uniqid_name']}"
      [
        row['ta_owner_name'], helpers.format_report_date(row['forward_date']), row['candidate_name'], row['requirement_name'],
        row['ta_leads'], row['skills'], row['company_name'], row['total_experience'], row['current_ctc'],
        row['expected_ctc'], row['notice_period'], row['serving_notice'], helpers.format_report_date(row['lwd']),
        row['current_location'], row['preferred_location'], resume_url
      ]
    end

    generate_and_send_excel("TA_Owner_Reports", headers, data_rows)
  end

  def pipeline_report
    @report_data = generate_pipeline_report(@start_date, @end_date)
  end

  def export_pipeline_report
    report_data = generate_pipeline_report(@start_date, @end_date)

    headers = [
      'TA Owner', 'Group Name', 'Requirement Name', 'Forwarded', 'Skills',
      'Shortlisted', 'No of Candidates Interviewed', 'Total Rounds of Interviews', 'Total EHD Sent',
      'Engineering Select', 'HAC', 'Total YTO', 'Offered', 'Not Accepted', 'Joined',
      'Not Joined', 'Rejected'
    ]

    data_rows = report_data.map do |row|
      [
        row['ta_owner_name'], row['group_name'], row['requirement_name'], row['total_forwards'],
        row['skills'],
        row['total_shortlists'], row['total_interviews'], row['total_rounds'], row['total_ehd'],
        row['total_eng_select'], row['total_hac'], row['total_yto'], row['total_offered'],
        row['total_not_accepted'], row['total_joined'], row['total_not_joined'], row['total_rejects']
      ]
    end

    generate_and_send_excel("Requirement_Pipeline_Reports", headers, data_rows)
  end

  def interview_reports_ta_owner
    @report_data = generate_interview_ta_owner_report(@start_date, @end_date, @employee)
  end

  def export_interview_reports_ta_owner
    report_data = generate_interview_ta_owner_report(@start_date, @end_date, @employee)

    headers = [
      'TA Owner', 'Candidate Name', 'Requirement Name', 'Interview Date', 'Interview Time',
      'Interview Mode', 'Panel Name', 'Apps Link', 'Rounds (L1/L2/L3)', 'Status',
      'Interview Cancelled/Deleted'
    ]

    data_rows = report_data.map do |row|
      resume_url = if row['uniqid_name'].present?
        "#{APP_CONFIG['host_name']}/resumes/show/#{row['uniqid_name']}"
      else
        ''
      end

      [
        row['ta_owner_name'], row['candidate_name'], row['requirement_name'],
        helpers.format_report_date(row['interview_date']), helpers.format_interview_time(row['interview_time']),
        row['interview_mode'], row['panel_name'], resume_url, row['round_label'], row['status_label'],
        row['cancelled_flag']
      ]
    end

    generate_and_send_excel("Interview_Reports_TA_Owner", headers, data_rows)
  end

  def interview_reports_per_requirement
    @report_data = generate_interview_per_requirement_report(@start_date, @end_date)
  end

  def export_interview_reports_per_requirement
    report_data = generate_interview_per_requirement_report(@start_date, @end_date)

    headers = [
      'Requirement Name', 'Candidate Name', 'Interview Date', 'Interview Time',
      'Interview Mode', 'Panel Name', 'Link', 'Rounds', 'Status',
      'Interview Cancelled/Deleted', 'TA Owner'
    ]

    data_rows = report_data.map do |row|
      resume_url = row['uniqid_name'].present? ? "#{APP_CONFIG['host_name']}/resumes/show/#{row['uniqid_name']}" : ''
      [
        row['requirement_name'], row['candidate_name'],
        helpers.format_report_date(row['interview_date']), helpers.format_interview_time(row['interview_time']),
        row['interview_mode'], row['panel_name'], resume_url, row['round_label'], row['status_label'],
        row['cancelled_flag'], row['ta_owner_name']
      ]
    end

    generate_and_send_excel("Interview_Reports_Per_Requirement", headers, data_rows)
  end

  private

  def set_employee
    @employee = get_current_employee
  end

  def set_date_range
    @period = params[:period] || 'daily'
    
    case @period
    when 'daily'
      date_param = params[:date].present? ? params[:date] : params[:start_date]
      @start_date = date_param.present? ? Date.parse(date_param.to_s) : Date.today
      @end_date = @start_date
    when 'monthly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      @end_date = @start_date.end_of_month
    when 'annually'
      base = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today
      @start_date = base.beginning_of_year
      @end_date = base.end_of_year
    else # Default to weekly
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
      @end_date = @start_date + 6.days
    end
  end

  def generate_and_send_excel(base_filename, headers, data_rows)
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = base_filename.tr('_', ' ')
    
    # Write headers
    headers.each_with_index do |header, col_num|
      cell = worksheet.add_cell(0, col_num, header)
      cell.change_fill('FFCCCCCC')
      cell.change_font_bold(true)
    end
    
    # Write data rows
    data_rows.each_with_index do |row_values, row_idx|
      row_values.each_with_index do |value, col_idx|
        worksheet.add_cell(row_idx + 1, col_idx, value)
      end
    end
    
    filename = "#{base_filename}_#{@period.capitalize}_#{@start_date.strftime('%Y%m%d')}_#{@end_date.strftime('%Y%m%d')}.xlsx"
    output_path = Rails.root.join('tmp', filename)
    workbook.write(output_path)
    
    send_file output_path,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  end

  def generate_requirements_report(start_date, end_date)
    start_dt = "#{start_date} 00:00:00"
    end_dt = "#{end_date} 23:59:59"
    
    sql = <<-SQL
      SELECT 
        COALESCE(grp.name, 'N/A') AS group_name,
        requirement.id AS requirement_id,
        requirement.name AS requirement_name,
        COALESCE(ta_manager.name, 'N/A') AS ta_manager_name,
        COALESCE(SUM(CASE WHEN forward.id IS NOT NULL THEN 1 ELSE 0 END), 0) AS total_forwards,
        COALESCE(SUM(CASE WHEN req_match.status = 'SHORTLISTED' AND req_match.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_shortlists,
        COALESCE(COUNT(DISTINCT CASE WHEN interview.id IS NOT NULL AND interview.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN req_match.resume_id END), 0) AS total_interviews,
        COALESCE(COUNT(DISTINCT CASE WHEN interview.interview_level = 1 AND feedback.id IS NOT NULL AND interview.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN req_match.id END), 0) AS total_l1_completed,
        COALESCE(COUNT(DISTINCT CASE WHEN interview.interview_level = 2 AND feedback.id IS NOT NULL AND interview.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN req_match.id END), 0) AS total_l2_completed,
        COALESCE(COUNT(DISTINCT CASE WHEN interview.interview_level = 3 AND feedback.id IS NOT NULL AND interview.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN req_match.id END), 0) AS total_l3_completed,
        COALESCE(SUM(CASE WHEN req_match.status = 'YTO' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_yto,
        COALESCE(SUM(CASE WHEN req_match.status = 'HAC' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_hac,
        COALESCE(SUM(CASE WHEN req_match.status = 'HOLD' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_hold,
        COALESCE(SUM(CASE WHEN req_match.status = 'OFFERED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_offered,
        COALESCE(SUM(CASE WHEN req_match.status = 'N_ACCEPTED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_not_accepted,
        COALESCE(SUM(CASE WHEN req_match.status = 'JOINING' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_joined,
        COALESCE(SUM(CASE WHEN req_match.status = 'NOT JOINED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_not_joined,
        COALESCE(SUM(CASE WHEN req_match.status = 'REJECTED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_rejects
      FROM requirements requirement
      LEFT JOIN `groups` grp ON requirement.group_id = grp.id
      LEFT JOIN employees ta_manager ON requirement.employee_id = ta_manager.id
      LEFT JOIN req_matches req_match ON requirement.id = req_match.requirement_id
      LEFT JOIN interviews interview ON interview.req_match_id = req_match.id
      LEFT JOIN feedbacks feedback ON feedback.interview_id = interview.id
      LEFT JOIN forwards_requirements forward_req ON requirement.id = forward_req.requirement_id
      LEFT JOIN forwards forward ON forward.id = forward_req.forward_id AND forward.created_at BETWEEN '#{start_dt}' AND '#{end_dt}'
      WHERE requirement.status = 'OPEN'
      GROUP BY requirement.id, requirement.name, grp.id, grp.name, ta_manager.id, ta_manager.name
      ORDER BY grp.name, requirement.name
    SQL
    
    ActiveRecord::Base.connection.select_all(sql).to_a
  end

  def generate_ta_owner_report(start_date, end_date, current_employee = nil)
    start_dt = "#{start_date} 00:00:00"
    end_dt = "#{end_date} 23:59:59"

    ta_lead_filter = if current_employee && !current_employee.is_TA_HEAD? && !current_employee.is_ADMIN?
      emp_id = current_employee.id.to_i
      # ta_lead_id: legacy single TA lead per requirement; requirements_ta_leads: HABTM for multiple TA leads
      " AND requirement.id IS NOT NULL AND (requirement.ta_lead_id = #{emp_id} OR requirement.id IN (SELECT requirement_id FROM requirements_ta_leads WHERE employee_id = #{emp_id}))"
    else
      ""
    end

    sql = <<-SQL
      SELECT 
        ta_owner.name AS ta_owner_name,
        DATE(forward.created_at) AS forward_date,
        resume.name AS candidate_name,
        requirement.name AS requirement_name,
        requirement.id AS requirement_id,
        COALESCE((
          SELECT GROUP_CONCAT(DISTINCT emp.name ORDER BY emp.name SEPARATOR ', ')
          FROM (
            SELECT r.ta_lead_id AS employee_id FROM requirements r WHERE r.id = requirement.id AND r.ta_lead_id IS NOT NULL AND r.ta_lead_id != 0
            UNION
            SELECT rtl.employee_id FROM requirements_ta_leads rtl WHERE rtl.requirement_id = requirement.id
          ) AS lead_ids
          JOIN employees emp ON emp.id = lead_ids.employee_id
        ), '') AS ta_leads,
        COALESCE(resume.skills, '') AS skills,
        COALESCE(resume.current_company, '') AS company_name,
        CASE 
          WHEN resume.exp_in_months IS NOT NULL THEN CONCAT(FLOOR(resume.exp_in_months / 12), '.', resume.exp_in_months % 12, ' years')
          WHEN resume.experience IS NOT NULL THEN resume.experience
          ELSE ''
        END AS total_experience,
        COALESCE(resume.ctc, 0) AS current_ctc,
        COALESCE(resume.expected_ctc, 0) AS expected_ctc,
        COALESCE(resume.notice, 0) AS notice_period,
        CASE WHEN resume.notice > 0 THEN 'Yes' ELSE 'No' END AS serving_notice,
        COALESCE(DATE(resume.joining_date), '') AS lwd,
        COALESCE(resume.location, '') AS current_location,
        COALESCE(resume.preferred_location, '') AS preferred_location,
        uniqid.name AS uniqid_name
      FROM resumes resume
      INNER JOIN employees ta_owner ON resume.ta_owner_id = ta_owner.id
      INNER JOIN forwards forward ON resume.id = forward.resume_id AND forward.created_at BETWEEN '#{start_dt}' AND '#{end_dt}'
      LEFT JOIN forwards_requirements forward_req ON forward.id = forward_req.forward_id
      LEFT JOIN requirements requirement ON forward_req.requirement_id = requirement.id
      LEFT JOIN uniqids uniqid ON resume.uniqid_id = uniqid.id
      WHERE resume.ta_owner_id IS NOT NULL#{ta_lead_filter}
      ORDER BY ta_owner.name, forward.created_at, resume.name
    SQL

    ActiveRecord::Base.connection.select_all(sql).to_a
  end

  def generate_pipeline_report(start_date, end_date)
    start_dt = "#{start_date} 00:00:00"
    end_dt = "#{end_date} 23:59:59"

    sql = <<-SQL
      SELECT
        COALESCE(grp.name, 'N/A') AS group_name,
        requirement.id AS requirement_id,
        requirement.name AS requirement_name,
        COALESCE(requirement.skill, '') AS skills,
        COALESCE((
          SELECT GROUP_CONCAT(DISTINCT emp.name ORDER BY emp.name SEPARATOR ', ')
          FROM (
            SELECT r.ta_lead_id AS employee_id FROM requirements r WHERE r.id = requirement.id AND r.ta_lead_id IS NOT NULL AND r.ta_lead_id != 0
            UNION
            SELECT rtl.employee_id FROM requirements_ta_leads rtl WHERE rtl.requirement_id = requirement.id
          ) AS lead_ids
          JOIN employees emp ON emp.id = lead_ids.employee_id
        ), 'N/A') AS ta_owner_name,
        COALESCE(SUM(CASE WHEN forward.id IS NOT NULL THEN 1 ELSE 0 END), 0) AS total_forwards,
        COALESCE(SUM(CASE WHEN req_match.status = 'SHORTLISTED' AND req_match.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_shortlists,
        COALESCE(COUNT(DISTINCT CASE WHEN interview.id IS NOT NULL AND interview.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN req_match.resume_id END), 0) AS total_interviews,
        COALESCE(COUNT(CASE WHEN interview.id IS NOT NULL AND interview.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 END), 0) AS total_rounds,
        COALESCE(SUM(CASE WHEN req_match.status = 'EHD' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_ehd,
        COALESCE(SUM(CASE WHEN req_match.status = 'ENG_SELECT' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_eng_select,
        COALESCE(SUM(CASE WHEN req_match.status = 'HAC' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_hac,
        COALESCE(SUM(CASE WHEN req_match.status = 'YTO' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_yto,
        COALESCE(SUM(CASE WHEN req_match.status = 'OFFERED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_offered,
        COALESCE(SUM(CASE WHEN req_match.status = 'N_ACCEPTED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_not_accepted,
        COALESCE(COUNT(DISTINCT CASE WHEN resume.overall_status = 'JOINED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN req_match.id END), 0) AS total_joined,
        COALESCE(SUM(CASE WHEN req_match.status = 'NOT JOINED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_not_joined,
        COALESCE(SUM(CASE WHEN req_match.status = 'REJECTED' AND req_match.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_rejects
      FROM requirements requirement
      LEFT JOIN `groups` grp ON requirement.group_id = grp.id
      LEFT JOIN req_matches req_match ON requirement.id = req_match.requirement_id
      LEFT JOIN resumes resume ON req_match.resume_id = resume.id
      LEFT JOIN interviews interview ON interview.req_match_id = req_match.id
      LEFT JOIN forwards_requirements forward_req ON requirement.id = forward_req.requirement_id
      LEFT JOIN forwards forward ON forward.id = forward_req.forward_id AND forward.created_at BETWEEN '#{start_dt}' AND '#{end_dt}'
      WHERE requirement.status = 'OPEN'
      GROUP BY requirement.id, requirement.name, requirement.skill, grp.id, grp.name
      ORDER BY grp.name, requirement.name
    SQL

    ActiveRecord::Base.connection.select_all(sql).to_a
  end

  def generate_interview_ta_owner_report(start_date, end_date, current_employee = nil)
    start_dt = start_date
    end_dt = end_date

    ta_lead_filter = if current_employee && !current_employee.is_TA_HEAD? && !current_employee.is_ADMIN?
      emp_id = current_employee.id.to_i
      " AND requirement.id IS NOT NULL AND (requirement.ta_lead_id = #{emp_id} OR requirement.id IN (SELECT requirement_id FROM requirements_ta_leads WHERE employee_id = #{emp_id}))"
    else
      ""
    end

    sql = <<-SQL
      SELECT
        ta_owner.name AS ta_owner_name,
        resume.name AS candidate_name,
        requirement.name AS requirement_name,
        interview.interview_date,
        interview.interview_time,
        CASE interview.itype
          WHEN 'TELECONF' THEN 'MS Teams Audio'
          WHEN 'VIDEOCONF' THEN 'MS Teams Video'
          WHEN 'TELEPHONE' THEN 'Telephone'
          ELSE 'Face to Face'
        END AS interview_mode,
        interviewer.name AS panel_name,
        uniqid.name AS uniqid_name,
        CASE
          WHEN interview.interview_level = 1 THEN 'L1'
          WHEN interview.interview_level = 2 THEN 'L2'
          WHEN interview.interview_level = 3 THEN 'L3'
          ELSE ''
        END AS round_label,
        CASE interview.status
          WHEN 'DECLINED' THEN 'Declined'
          WHEN 'CANDIDATE_NO_SHOW' THEN 'Candidate No Show'
          WHEN 'PANEL_NO_SHOW' THEN 'Panel No Show'
          ELSE 'Scheduled'
        END AS status_label,
        CASE
          WHEN interview.status IN ('DECLINED', 'CANDIDATE_NO_SHOW', 'PANEL_NO_SHOW') THEN 'Yes'
          ELSE 'No'
        END AS cancelled_flag
      FROM interviews interview
      INNER JOIN req_matches req_match ON interview.req_match_id = req_match.id
      INNER JOIN resumes resume ON req_match.resume_id = resume.id
      LEFT JOIN requirements requirement ON req_match.requirement_id = requirement.id
      LEFT JOIN employees ta_owner ON resume.ta_owner_id = ta_owner.id
      LEFT JOIN employees interviewer ON interview.employee_id = interviewer.id
      LEFT JOIN uniqids uniqid ON resume.uniqid_id = uniqid.id
      WHERE resume.ta_owner_id IS NOT NULL
        AND interview.interview_date BETWEEN '#{start_dt}' AND '#{end_dt}'
        #{ta_lead_filter}
      ORDER BY ta_owner.name, interview.interview_date, interview.interview_time, resume.name
    SQL

    ActiveRecord::Base.connection.select_all(sql).to_a
  end

  def generate_interview_per_requirement_report(start_date, end_date)
    start_dt = start_date
    end_dt = end_date

    sql = <<-SQL
      SELECT
        COALESCE(requirement.name, '') AS requirement_name,
        requirement.id AS requirement_id,
        resume.name AS candidate_name,
        interview.interview_date,
        interview.interview_time,
        CASE interview.itype
          WHEN 'TELECONF' THEN 'MS Teams Audio'
          WHEN 'VIDEOCONF' THEN 'MS Teams Video'
          WHEN 'TELEPHONE' THEN 'Telephone'
          ELSE 'Face to Face'
        END AS interview_mode,
        interviewer.name AS panel_name,
        uniqid.name AS uniqid_name,
        CASE
          WHEN interview.interview_level = 1 THEN 'L1'
          WHEN interview.interview_level = 2 THEN 'L2'
          WHEN interview.interview_level = 3 THEN 'L3'
          ELSE ''
        END AS round_label,
        CASE interview.status
          WHEN 'DECLINED' THEN 'Declined'
          WHEN 'CANDIDATE_NO_SHOW' THEN 'Candidate No Show'
          WHEN 'PANEL_NO_SHOW' THEN 'Panel No Show'
          ELSE 'Scheduled'
        END AS status_label,
        CASE
          WHEN interview.status IN ('DECLINED', 'CANDIDATE_NO_SHOW', 'PANEL_NO_SHOW') THEN 'Yes'
          ELSE 'No'
        END AS cancelled_flag,
        COALESCE(ta_owner.name, '') AS ta_owner_name
      FROM interviews interview
      INNER JOIN req_matches req_match ON interview.req_match_id = req_match.id
      INNER JOIN resumes resume ON req_match.resume_id = resume.id
      LEFT JOIN requirements requirement ON req_match.requirement_id = requirement.id
      LEFT JOIN employees ta_owner ON resume.ta_owner_id = ta_owner.id
      LEFT JOIN employees interviewer ON interview.employee_id = interviewer.id
      LEFT JOIN uniqids uniqid ON resume.uniqid_id = uniqid.id
      WHERE interview.interview_date BETWEEN '#{start_dt}' AND '#{end_dt}'
      ORDER BY requirement.name, interview.interview_date, interview.interview_time, resume.name
    SQL

    ActiveRecord::Base.connection.select_all(sql).to_a
  end
end
