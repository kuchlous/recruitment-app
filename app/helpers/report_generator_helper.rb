# frozen_string_literal: true

module ReportGeneratorHelper
  def pipeline_reports_grid_rows(report_data)
    Array(report_data).map do |row|
      {
        ta_owner_name: row['ta_owner_name'].to_s,
        group_name: row['group_name'].to_s,
        requirement_name: row['requirement_name'].to_s,
        requirement_id: row['requirement_id'],
        total_forwards: row['total_forwards'].to_i,
        skills: row['skills'].to_s,
        skills_display: truncate(row['skills'].presence || '', length: 100),
        total_shortlists: row['total_shortlists'].to_i,
        total_interviews: row['total_interviews'].to_i,
        total_rounds: row['total_rounds'].to_i,
        total_ehd: row['total_ehd'].to_i,
        total_eng_select: row['total_eng_select'].to_i,
        total_hac: row['total_hac'].to_i,
        total_yto: row['total_yto'].to_i,
        total_offered: row['total_offered'].to_i,
        total_not_accepted: row['total_not_accepted'].to_i,
        total_joined: row['total_joined'].to_i,
        total_not_joined: row['total_not_joined'].to_i,
        total_rejects: row['total_rejects'].to_i
      }
    end
  end

  def requirement_reports_grid_rows(report_data)
    Array(report_data).map do |row|
      {
        group_name: row['group_name'].to_s,
        requirement_name: row['requirement_name'].to_s,
        requirement_id: row['requirement_id'],
        total_forwards: row['total_forwards'].to_i,
        total_shortlists: row['total_shortlists'].to_i,
        total_interviews: row['total_interviews'].to_i,
        total_l1_completed: row['total_l1_completed'].to_i,
        total_l2_completed: row['total_l2_completed'].to_i,
        total_l3_completed: row['total_l3_completed'].to_i,
        total_yto: row['total_yto'].to_i,
        total_hac: row['total_hac'].to_i,
        total_hold: row['total_hold'].to_i,
        total_offered: row['total_offered'].to_i,
        total_not_accepted: row['total_not_accepted'].to_i,
        total_joined: row['total_joined'].to_i,
        total_not_joined: row['total_not_joined'].to_i,
        total_rejects: row['total_rejects'].to_i,
        ta_manager_name: row['ta_manager_name'].to_s
      }
    end
  end

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
