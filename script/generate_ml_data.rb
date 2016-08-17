req = Requirement.find(ARGV[2].to_i)
f = File.open("tmp/" + req.name.gsub(/(?![A-Za-z0-9])./, '') + '.mltxt', "w")
req.forwards.each do |fwd|
  resume = fwd.resume
  puts "Processing resume " + resume.name
  txtfile = RAILS_ROOT + "/" + APP_CONFIG['upload_directory'] + "/" + resume.file_name + ".txt"
  if (File.exists?(txtfile) && File.size(txtfile) > 100)
    status = nil
    decided_by = nil
    resume.comments.each do |c|
      if c.comment.match("SHORTLISTED") || c.comment.match("nterview")
        status = "SHORTLISTED" 
        decided_by = c.employee
        break
      end
    end
    unless status 
      resume.comments.each do |c|
        if c.comment.match("REJECTED")
          status = "REJECTED"
          decided_by = c.employee
          break
        end
      end
    end
    next unless status
    f.puts "NAME: " + fwd.resume.name
    f.puts "SUMMARY: " + fwd.resume.summary.gsub(/\r\n/,'')
    f.puts "EXPERIENCE: " + fwd.resume.experience
    f.puts "QUALIFICATION: " + fwd.resume.qualification.gsub(/\r\n/,'')
    f.puts "CTC: " + fwd.resume.ctc.to_s
    f.puts "E_CTC: " + fwd.resume.expected_ctc.to_s
    f.puts "NOTICE: " + fwd.resume.notice.to_s
    f.puts "LOCATION: " + (fwd.resume.location ? fwd.resume.location : " ")
    f.puts "COMPANY: " + (fwd.resume.current_company ? fwd.resume.current_company : " ")
    f.puts "STATUS: " + status
    f.puts "DECIDED_BY: " + decided_by.id.to_s
    f.write File.read(RAILS_ROOT + "/" + APP_CONFIG['upload_directory'] + "/" + fwd.resume.file_name + ".txt").gsub(/\n/,' ')
    f.puts "\n================================"
  end
end
f.close
