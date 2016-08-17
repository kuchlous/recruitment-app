desc 'This finds resumes from top tier colleges'
task :top_tier_resumes do |t, env|
  Rake::Task["environment"].invoke

  bits_r = Resume.all.find_all { |r| /BITS/i.match(r.qualification) || /Birla/i.match(r.qualification) }
  iit_r = Resume.all.find_all { |r| /IIT/i.match(r.qualification) || /Indian/i.match(r.qualification) }
  rec_r = Resume.all.find_all { |r| /REC/i.match(r.qualification) || /Regional/i.match(r.qualification) }
  gec_r = Resume.all.find_all { |r| /gEC/i.match(r.qualification) || /Government/i.match(r.qualification) }


  areas = {"PD" => {:rx => [/PD/, /Physical/i]},
          "VERIFICATION" => {:rx => [/Verification/i, /SV/]},
          "RTL" => {:rx => [/RTL/]},
          "DFT" => {:rx => [/DFT/]}}
           
  pd_reqs = []
  Requirement.all.each do |r|
    areas.each do |area, props|
      props[:rx].each do |rx|
        if (rx.match(r.name))
          props[:reqs] ||= []
          props[:reqs] << r 
        end
      end
    end 
  end

  areas.each do |area, props|
    puts "#{area} #{props[:reqs].collect { |r| r.name }.join(',') }"
  end

  areas.each do |area, props|
    props[:resumes] = []
    props[:reqs].each do |req|
      req.req_matches.each do |m|
        props[:resumes] << m.resume
      end
      req.forwards.each do |f|
        props[:resumes] << f.resume
      end
    end
    props[:resumes].uniq!
  end

  f = File.open("top_tier.csv", "w")
  areas.each do |area, props|
    props[:resumes] = props[:resumes].find_all {|r| /BITS/i.match(r.qualification) || /Birla/i.match(r.qualification) ||
                                   /IIT/i.match(r.qualification) || /Indian/i.match(r.qualification) ||
                                   /REC/i.match(r.qualification) || /Regional/i.match(r.qualification) ||
                                   /GEC/i.match(r.qualification) || /Government/i.match(r.qualification) }

    props[:resumes].each do |r|
      f.puts "#{area},#{r.name},\"#{r.qualification}\",#{r.phone},#{r.email},#{r.location},#{r.current_company},#{r.resume_overall_status}, #{r.created_at.day}/#{r.created_at.month}/#{r.created_at.year}"
    end
  end

  f.close
end
