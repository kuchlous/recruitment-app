module RequirementHelper
  def get_forwards_count(req)
    req.forwards.where(status:"FORWARDED").count()
  end 
  def get_shortlisted_count(req)
    req.req_matches.where(status:"SHORTLISTED").count()
  end 
end
