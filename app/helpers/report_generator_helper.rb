# frozen_string_literal: true

module ReportGeneratorHelper
  def ta_owner_reports_grid_rows(report_data)
    Array(report_data).map do |row|
      {
        ta_owner_name: row['ta_owner_name'].to_s,
        forward_date: format_report_date(row['forward_date']),
        candidate_name: row['candidate_name'].to_s,
        uniqid_name: row['uniqid_name'].to_s,
        requirement_name: row['requirement_name'].to_s,
        requirement_id: row['requirement_id'],
        ta_leads: row['ta_leads'].to_s,
        skills: row['skills'].to_s,
        skills_display: truncate(row['skills'].presence || '', length: 50),
        company_name: row['company_name'].to_s,
        total_experience: row['total_experience'].to_s,
        current_ctc: row['current_ctc'].to_s,
        expected_ctc: row['expected_ctc'].to_s,
        notice_period: row['notice_period'].to_s,
        serving_notice: row['serving_notice'].to_s,
        lwd: format_report_date(row['lwd']),
        current_location: row['current_location'].to_s,
        preferred_location: row['preferred_location'].to_s
      }
    end
  end
end
