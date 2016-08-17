req = Requirement.find(49)
req.forwards.each do |fwd|
  resume = fwd.resume
  puts "Processing resume " + resume.name
  if (File.exists?(RAILS_ROOT + "/" + APP_CONFIG['upload_directory'] + "/" + resume.file_name + ".txt"))
    if resume.req_matches.map { |m| m.requirement }.include? req
      puts "SHORTLISTED : COMMENTS"
      comments = resume.comments.find_all { |c| c.comment.include?('SHORTLISTED') }
      comments.each do |c| 
        puts c.comment
      end
    else
    end
  end
end
