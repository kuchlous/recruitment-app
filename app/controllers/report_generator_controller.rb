class ReportGeneratorController < ApplicationController
  require 'rubyXL'
  require 'rubyXL/convenience_methods'

  # check_for_login redirects to index for login
  before_action :check_for_login
  before_action :check_for_HR_or_ADMIN

  def reports
    @employee = get_current_employee
    
    # Get report period (weekly, daily, monthly)
    @period = params[:period] || 'weekly'
    
    # Calculate date range based on period
    case @period
    when 'daily'
      @start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @end_date = @start_date
    when 'weekly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
      @end_date = @start_date + 6.days # Add 7 days (including start date = 6 days added)
    when 'monthly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      @end_date = @start_date.end_of_month
    end
    
    # Generate report data using SQL queries
    @report_data = generate_weekly_report(@start_date, @end_date)
  end

  def export_reports
    @employee = get_current_employee
    
    # Get report period (weekly, daily, monthly)
    @period = params[:period] || 'weekly'
    
    # Calculate date range based on period (same logic as reports action)
    case @period
    when 'daily'
      @start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @end_date = @start_date
    when 'weekly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
      @end_date = @start_date + 6.days
    when 'monthly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      @end_date = @start_date.end_of_month
    end
    
    # Generate report data
    report_data = generate_weekly_report(@start_date, @end_date)
    
    # Create Excel workbook
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = "Reports"
    
    # Define headers
    headers = [
      'Group Name', 'Requirement Name', 'Total Forward', 'Total Shortlists',
      'Total Interviews (Candidates)', 'Total L1 Completed', 'Total L2 Completed',
      'Total L3 Completed', 'Total YTO', 'Total HAC', 'Total Hold',
      'Total Offered', 'Total Not Accepted', 'Total Joined', 'Total Not Joined',
      'Total Rejects', 'TA Manager'
    ]
    
    # Write headers
    headers.each_with_index do |header, col_num|
      cell = worksheet.add_cell(0, col_num, header)
      cell.change_fill('FFCCCCCC') # Light gray background
      cell.change_font_bold(true)
    end
    
    # Write data rows
    row_num = 1
    report_data.each do |row|
      worksheet.add_cell(row_num, 0, row['group_name'])
      worksheet.add_cell(row_num, 1, row['requirement_name'])
      worksheet.add_cell(row_num, 2, row['total_forwards'])
      worksheet.add_cell(row_num, 3, row['total_shortlists'])
      worksheet.add_cell(row_num, 4, row['total_interviews'])
      worksheet.add_cell(row_num, 5, row['total_l1_completed'])
      worksheet.add_cell(row_num, 6, row['total_l2_completed'])
      worksheet.add_cell(row_num, 7, row['total_l3_completed'])
      worksheet.add_cell(row_num, 8, row['total_yto'])
      worksheet.add_cell(row_num, 9, row['total_hac'])
      worksheet.add_cell(row_num, 10, row['total_hold'])
      worksheet.add_cell(row_num, 11, row['total_offered'])
      worksheet.add_cell(row_num, 12, row['total_not_accepted'])
      worksheet.add_cell(row_num, 13, row['total_joined'])
      worksheet.add_cell(row_num, 14, row['total_not_joined'])
      worksheet.add_cell(row_num, 15, row['total_rejects'])
      worksheet.add_cell(row_num, 16, row['ta_manager_name'])
      row_num += 1
    end
    
    # Generate filename
    period_label = @period.capitalize
    filename = "Reports_#{period_label}_#{@start_date.strftime('%Y%m%d')}_#{@end_date.strftime('%Y%m%d')}.xlsx"
    
    # Save to tmp directory (like other exports in the codebase)
    output = "#{Rails.root}/tmp/#{filename}"
    workbook.write(output)
    
    # Send file
    send_file output,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  end

  def ta_owner_reports
    @employee = get_current_employee
    
    # Get report period (weekly, daily, monthly)
    @period = params[:period] || 'weekly'
    
    # Calculate date range based on period
    case @period
    when 'daily'
      @start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @end_date = @start_date
    when 'weekly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
      @end_date = @start_date + 6.days # Add 7 days (including start date = 6 days added)
    when 'monthly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      @end_date = @start_date.end_of_month
    end
    
    # Generate report data using SQL queries
    @report_data = generate_ta_owner_report(@start_date, @end_date)
  end

  def export_ta_owner_reports
    @employee = get_current_employee
    
    # Get report period (weekly, daily, monthly)
    @period = params[:period] || 'weekly'
    
    # Calculate date range based on period (same logic as ta_owner_reports action)
    case @period
    when 'daily'
      @start_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @end_date = @start_date
    when 'weekly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
      @end_date = @start_date + 6.days
    when 'monthly'
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
      @end_date = @start_date.end_of_month
    end
    
    # Generate report data
    report_data = generate_ta_owner_report(@start_date, @end_date)
    
    # Create Excel workbook
    workbook = RubyXL::Workbook.new
    worksheet = workbook[0]
    worksheet.sheet_name = "TA Owner Reports"
    
    # Define headers
    headers = [
      'TA Owner', 'Forward Date', 'Candidate Name', 'Requirement Name', 'Skills',
      'Company Name', 'Total Experience', 'Current CTC', 'Expected CTC', 'Notice Period',
      'Serving Notice Period (Yes/No)', 'LWD', 'Current Location', 'Preferred Location', 'Link', 'Status'
    ]
    
    # Write headers
    headers.each_with_index do |header, col_num|
      cell = worksheet.add_cell(0, col_num, header)
      cell.change_fill('FFCCCCCC') # Light gray background
      cell.change_font_bold(true)
    end
    
    # Write data rows
    row_num = 1
    report_data.each do |row|
      # Build resume URL
      resume_url = "#{APP_CONFIG['host_name']}/resumes/show/#{row['uniqid_name']}"
      
      worksheet.add_cell(row_num, 0, row['ta_owner_name'])
      worksheet.add_cell(row_num, 1, row['forward_date'])
      worksheet.add_cell(row_num, 2, row['candidate_name'])
      worksheet.add_cell(row_num, 3, row['requirement_name'])
      worksheet.add_cell(row_num, 4, row['skills'])
      worksheet.add_cell(row_num, 5, row['company_name'])
      worksheet.add_cell(row_num, 6, row['total_experience'])
      worksheet.add_cell(row_num, 7, row['current_ctc'])
      worksheet.add_cell(row_num, 8, row['expected_ctc'])
      worksheet.add_cell(row_num, 9, row['notice_period'])
      worksheet.add_cell(row_num, 10, row['serving_notice'])
      worksheet.add_cell(row_num, 11, row['lwd'])
      worksheet.add_cell(row_num, 12, row['current_location'])
      worksheet.add_cell(row_num, 13, row['preferred_location'])
      worksheet.add_cell(row_num, 14, resume_url)
      worksheet.add_cell(row_num, 15, row['status'])
      row_num += 1
    end
    
    # Generate filename
    period_label = @period.capitalize
    filename = "TA_Owner_Reports_#{period_label}_#{@start_date.strftime('%Y%m%d')}_#{@end_date.strftime('%Y%m%d')}.xlsx"
    
    # Save to tmp directory
    output = "#{Rails.root}/tmp/#{filename}"
    workbook.write(output)
    
    # Send file
    send_file output,
              filename: filename,
              type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              disposition: 'attachment'
  end

private
  def generate_weekly_report(start_date, end_date)
    # Format dates for SQL
    start_datetime = "#{start_date} 00:00:00"
    end_datetime = "#{end_date} 23:59:59"
    
    # SQL query to get report data grouped by requirement
    # Using subqueries for better performance and accuracy
    sql = <<-SQL
      SELECT 
        COALESCE(g.name, 'N/A') AS group_name,
        r.id AS requirement_id,
        r.name AS requirement_name,
        COALESCE(e.name, 'N/A') AS ta_manager_name,
        COALESCE(forward_counts.total_forwards, 0) AS total_forwards,
        COALESCE(shortlist_counts.total_shortlists, 0) AS total_shortlists,
        COALESCE(interview_counts.total_interviews, 0) AS total_interviews,
        COALESCE(l1_counts.total_l1_completed, 0) AS total_l1_completed,
        COALESCE(l2_counts.total_l2_completed, 0) AS total_l2_completed,
        COALESCE(l3_counts.total_l3_completed, 0) AS total_l3_completed,
        COALESCE(yto_counts.total_yto, 0) AS total_yto,
        COALESCE(hac_counts.total_hac, 0) AS total_hac,
        COALESCE(hold_counts.total_hold, 0) AS total_hold,
        COALESCE(offered_counts.total_offered, 0) AS total_offered,
        COALESCE(not_accepted_counts.total_not_accepted, 0) AS total_not_accepted,
        COALESCE(joined_counts.total_joined, 0) AS total_joined,
        COALESCE(not_joined_counts.total_not_joined, 0) AS total_not_joined,
        COALESCE(reject_counts.total_rejects, 0) AS total_rejects
      FROM requirements r
      LEFT JOIN groups g ON r.group_id = g.id
      LEFT JOIN employees e ON r.employee_id = e.id
      LEFT JOIN (
        SELECT fr.requirement_id, COUNT(DISTINCT f.id) AS total_forwards
        FROM forwards_requirements fr
        INNER JOIN forwards f ON f.id = fr.forward_id
        WHERE f.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY fr.requirement_id
      ) AS forward_counts ON forward_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_shortlists
        FROM req_matches
        WHERE status = 'SHORTLISTED' 
          AND created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS shortlist_counts ON shortlist_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT rm.requirement_id, COUNT(DISTINCT rm.resume_id) AS total_interviews
        FROM req_matches rm
        INNER JOIN interviews i ON i.req_match_id = rm.id
        WHERE i.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY rm.requirement_id
      ) AS interview_counts ON interview_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT rm.requirement_id, COUNT(DISTINCT rm.id) AS total_l1_completed
        FROM req_matches rm
        INNER JOIN interviews i ON i.req_match_id = rm.id
        INNER JOIN feedbacks fdb ON fdb.interview_id = i.id
        WHERE i.interview_level = 1 
          AND i.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY rm.requirement_id
      ) AS l1_counts ON l1_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT rm.requirement_id, COUNT(DISTINCT rm.id) AS total_l2_completed
        FROM req_matches rm
        INNER JOIN interviews i ON i.req_match_id = rm.id
        INNER JOIN feedbacks fdb ON fdb.interview_id = i.id
        WHERE i.interview_level = 2 
          AND i.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY rm.requirement_id
      ) AS l2_counts ON l2_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT rm.requirement_id, COUNT(DISTINCT rm.id) AS total_l3_completed
        FROM req_matches rm
        INNER JOIN interviews i ON i.req_match_id = rm.id
        INNER JOIN feedbacks fdb ON fdb.interview_id = i.id
        WHERE i.interview_level = 3 
          AND i.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY rm.requirement_id
      ) AS l3_counts ON l3_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_yto
        FROM req_matches
        WHERE status = 'YTO' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS yto_counts ON yto_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_hac
        FROM req_matches
        WHERE status = 'HAC' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS hac_counts ON hac_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_hold
        FROM req_matches
        WHERE status = 'HOLD' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS hold_counts ON hold_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_offered
        FROM req_matches
        WHERE status = 'OFFERED' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS offered_counts ON offered_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_not_accepted
        FROM req_matches
        WHERE status = 'N_ACCEPTED' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS not_accepted_counts ON not_accepted_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_joined
        FROM req_matches
        WHERE status = 'JOINING' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS joined_counts ON joined_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_not_joined
        FROM req_matches
        WHERE status = 'NOT JOINED' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS not_joined_counts ON not_joined_counts.requirement_id = r.id
      LEFT JOIN (
        SELECT requirement_id, COUNT(DISTINCT id) AS total_rejects
        FROM req_matches
        WHERE status = 'REJECTED' 
          AND updated_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        GROUP BY requirement_id
      ) AS reject_counts ON reject_counts.requirement_id = r.id
      WHERE r.status = 'OPEN'
      ORDER BY g.name, r.name
    SQL
    
    # Use select_all which returns ActiveRecord::Result (works with all adapters)
    result = ActiveRecord::Base.connection.select_all(sql)
    # Convert to array of hashes
    result.map { |row| row }
  end

  def generate_ta_owner_report(start_date, end_date)
    # Format dates for SQL
    start_datetime = "#{start_date} 00:00:00"
    end_datetime = "#{end_date} 23:59:59"
    
    # SQL query to get TA Owner report data
    # Using UNION to combine forwards and req_matches
    sql = <<-SQL
      SELECT 
        ta_owner.name AS ta_owner_name,
        DATE(activity_date) AS forward_date,
        r.name AS candidate_name,
        req.name AS requirement_name,
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
        activity_status AS status
      FROM (
        SELECT 
          f.resume_id,
          f.created_at AS activity_date,
          f.status AS activity_status,
          fr.requirement_id
        FROM forwards f
        INNER JOIN forwards_requirements fr ON f.id = fr.forward_id
        WHERE f.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
        
        UNION ALL
        
        SELECT 
          rm.resume_id,
          rm.created_at AS activity_date,
          rm.status AS activity_status,
          rm.requirement_id
        FROM req_matches rm
        WHERE rm.created_at BETWEEN '#{start_datetime}' AND '#{end_datetime}'
      ) AS activities
      INNER JOIN resumes r ON activities.resume_id = r.id
      INNER JOIN employees ta_owner ON r.ta_owner_id = ta_owner.id
      LEFT JOIN uniqids u ON r.uniqid_id = u.id
      LEFT JOIN requirements req ON activities.requirement_id = req.id
      WHERE r.ta_owner_id IS NOT NULL
      ORDER BY ta_owner.name, activity_date, r.name
    SQL
    
    result = ActiveRecord::Base.connection.select_all(sql)
    result.map { |row| row }
  end
end
