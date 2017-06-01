module RequirementHelper
  def get_forwards_count(req)
    req.forwards.find_all_by_status("FORWARDED").count()
  end 
  def get_shortlisted_count(req)
    req.req_matches.find_all_by_status("SHORTLISTED").count()
  end 
end
