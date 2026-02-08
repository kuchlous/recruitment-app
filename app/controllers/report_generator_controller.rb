class ReportGeneratorController < ApplicationController
  require 'rubyXL'
  require 'rubyXL/convenience_methods'

  # check_for_login redirects to index for login
  before_action :check_for_login
  before_action :check_for_TA_HEAD
  before_action :set_employee
  before_action :set_date_range, only: [:reports, :export_reports, :ta_owner_reports, :export_ta_owner_reports]

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
    @report_data = generate_ta_owner_report(@start_date, @end_date)
  end

  def export_ta_owner_reports
    report_data = generate_ta_owner_report(@start_date, @end_date)
    
    headers = [
      'TA Owner', 'Forward Date', 'Candidate Name', 'Requirement Name', 'Skills',
      'Company Name', 'Total Experience', 'Current CTC', 'Expected CTC', 'Notice Period',
      'Serving Notice Period (Yes/No)', 'LWD', 'Current Location', 'Preferred Location', 'Link', 'Status'
    ]
    
    data_rows = report_data.map do |row|
      resume_url = "#{APP_CONFIG['host_name']}/resumes/show/#{row['uniqid_name']}"
      [
        row['ta_owner_name'], row['forward_date'], row['candidate_name'], row['requirement_name'],
        row['skills'], row['company_name'], row['total_experience'], row['current_ctc'],
        row['expected_ctc'], row['notice_period'], row['serving_notice'], row['lwd'],
        row['current_location'], row['preferred_location'], resume_url, row['status']
      ]
    end

    generate_and_send_excel("TA_Owner_Reports", headers, data_rows)
  end

  private

  def set_employee
    @employee = get_current_employee
  end

  def set_date_range
    @period = params[:period] || 'weekly'
    
    case @period
    when 'daily'
      @start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @end_date = @start_date
    when 'monthly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      @end_date = @start_date.end_of_month
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
        COALESCE(g.name, 'N/A') AS group_name,
        r.id AS requirement_id,
        r.name AS requirement_name,
        COALESCE(e.name, 'N/A') AS ta_manager_name,
        COALESCE(SUM(CASE WHEN f.id IS NOT NULL THEN 1 ELSE 0 END), 0) AS total_forwards,
        COALESCE(SUM(CASE WHEN rm.status = 'SHORTLISTED' AND rm.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_shortlists,
        COALESCE(COUNT(DISTINCT CASE WHEN i.id IS NOT NULL AND i.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN rm.resume_id END), 0) AS total_interviews,
        COALESCE(COUNT(DISTINCT CASE WHEN i.interview_level = 1 AND fdb.id IS NOT NULL AND i.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN rm.id END), 0) AS total_l1_completed,
        COALESCE(COUNT(DISTINCT CASE WHEN i.interview_level = 2 AND fdb.id IS NOT NULL AND i.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN rm.id END), 0) AS total_l2_completed,
        COALESCE(COUNT(DISTINCT CASE WHEN i.interview_level = 3 AND fdb.id IS NOT NULL AND i.created_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN rm.id END), 0) AS total_l3_completed,
        COALESCE(SUM(CASE WHEN rm.status = 'YTO' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_yto,
        COALESCE(SUM(CASE WHEN rm.status = 'HAC' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_hac,
        COALESCE(SUM(CASE WHEN rm.status = 'HOLD' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_hold,
        COALESCE(SUM(CASE WHEN rm.status = 'OFFERED' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_offered,
        COALESCE(SUM(CASE WHEN rm.status = 'N_ACCEPTED' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_not_accepted,
        COALESCE(SUM(CASE WHEN rm.status = 'JOINING' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_joined,
        COALESCE(SUM(CASE WHEN rm.status = 'NOT JOINED' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_not_joined,
        COALESCE(SUM(CASE WHEN rm.status = 'REJECTED' AND rm.updated_at BETWEEN '#{start_dt}' AND '#{end_dt}' THEN 1 ELSE 0 END), 0) AS total_rejects
      FROM requirements r
      LEFT JOIN `groups` g ON r.group_id = g.id
      LEFT JOIN employees e ON r.employee_id = e.id
      LEFT JOIN req_matches rm ON r.id = rm.requirement_id
      LEFT JOIN interviews i ON i.req_match_id = rm.id
      LEFT JOIN feedbacks fdb ON fdb.interview_id = i.id
      LEFT JOIN forwards_requirements fr ON r.id = fr.requirement_id
      LEFT JOIN forwards f ON f.id = fr.forward_id AND f.created_at BETWEEN '#{start_dt}' AND '#{end_dt}'
      WHERE r.status = 'OPEN'
      GROUP BY r.id, r.name, g.id, g.name, e.id, e.name
      ORDER BY g.name, r.name
    SQL
    
    ActiveRecord::Base.connection.select_all(sql).to_a
  end

  def generate_ta_owner_report(start_date, end_date)
    start_dt = "#{start_date} 00:00:00"
    end_dt = "#{end_date} 23:59:59"
    
    sql = <<-SQL
      SELECT 
        ta_owner.name AS ta_owner_name,
        DATE(COALESCE(rm.created_at, f.created_at)) AS forward_date,
        r.name AS candidate_name,
        COALESCE(req_rm.name, req_f.name) AS requirement_name,
        COALESCE(r.skills, '') AS skills,
        COALESCE(r.current_company, '') AS company_name,
        CASE 
          WHEN r.exp_in_months IS NOT NULL THEN CONCAT(FLOOR(r.exp_in_months / 12), '.', r.exp_in_months % 12, ' years')
          WHEN r.experience IS NOT NULL THEN r.experience
          ELSE ''
        END AS total_experience,
        COALESCE(r.ctc, 0) AS current_ctc,
        COALESCE(r.expected_ctc, 0) AS expected_ctc,
        COALESCE(r.notice, 0) AS notice_period,
        CASE WHEN r.notice > 0 THEN 'Yes' ELSE 'No' END AS serving_notice,
        COALESCE(DATE(r.joining_date), '') AS lwd,
        COALESCE(r.location, '') AS current_location,
        COALESCE(r.preferred_location, '') AS preferred_location,
        u.name AS uniqid_name,
        COALESCE(rm.status, f.status) AS status
      FROM resumes r
      INNER JOIN employees ta_owner ON r.ta_owner_id = ta_owner.id
      LEFT JOIN req_matches rm ON r.id = rm.resume_id AND rm.created_at BETWEEN '#{start_dt}' AND '#{end_dt}'
      LEFT JOIN requirements req_rm ON rm.requirement_id = req_rm.id
      LEFT JOIN forwards_requirements fr ON r.id = fr.requirement_id
      LEFT JOIN forwards f ON f.id = fr.forward_id AND f.created_at BETWEEN '#{start_dt}' AND '#{end_dt}'
      LEFT JOIN requirements req_f ON fr.requirement_id = req_f.id
      LEFT JOIN uniqids u ON r.uniqid_id = u.id
      WHERE r.ta_owner_id IS NOT NULL
        AND (rm.id IS NOT NULL OR f.id IS NOT NULL)
      ORDER BY ta_owner.name, COALESCE(rm.created_at, f.created_at), r.name
    SQL
    
    ActiveRecord::Base.connection.select_all(sql).to_a
  end
end
