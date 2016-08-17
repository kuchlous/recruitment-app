desc 'This finds resumes which are not joined'
task :pd_resumes do |t, env|
  Rake::Task["environment"].invoke
  pd_reqs = []
  Requirement.all.each do |r|
    if /DFT/.match(r.name) 
      pd_reqs << r
    end
  end

  pd_resumes = []
  pd_reqs.each do |req|
    req.req_matches.each do |m|
      pd_resumes << m.resume
    end
    req.forwards.each do |f|
      pd_resumes << f.resume
    end
  end

  pd_resumes.uniq!

  f = File.open("dft.csv", "w")
  pd_resumes.each do |r|
    if r.resume_overall_status != "Joined"
      f.puts "#{r.name},#{r.phone},#{r.email},#{r.location},#{r.current_company},#{r.resume_overall_status}, #{r.created_at.day}/#{r.created_at.month}/#{r.created_at.year}"
    end
  end

  f.close
end
