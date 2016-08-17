  require 'spreadsheet'
  def print_details(resumes, name, interviewer_hash, book)
    sheet = book.create_worksheet :name => name
    sheet.row(0).concat %w{Name Id Location Company Referral Notice NInterviews Interviews}
    puts "#{name} (#{resumes.size})"
    row = 1
    resumes.each do |r|
      num_interviews = 0
      sheet.row(row).push r.name
      print "#{r.id} "
      sheet.row(row).push r.id
      sheet.row(row).push r.location
      sheet.row(row).push r.current_company
      sheet.row(row).push r.referral_type
      sheet.row(row).push r.notice

      interviews = []
      r.req_matches.each do |match|
        interviews += match.interviews
      end
      int_employees = {}
      interviews.each do |i|
        int_employees[i.employee] = 1
      end
       
      print "#{int_employees.size} "
      sheet.row(row).push int_employees.size

      int_employees.each do |e, flag|
        interviewer_hash[e] ||= 0
        interviewer_hash[e] += 1
        print "#{e.name} "
        sheet.row(row).push e.name
      end
      row += 1
      print "\n"
    end
  end

  Spreadsheet.client_encoding = 'UTF-8'
  output                      = "#{RAILS_ROOT}/tmp/joining_status_#{Date.today.day}_#{Date.today.month}.xls"
  book                        = Spreadsheet::Workbook.new

  not_joined_resumes = Resume.find_all_by_status("NOT JOINED")
  not_joined_interviewer_hash = {}
  print_details(not_joined_resumes, "NOT JOINED", not_joined_interviewer_hash, book)
  joined_resumes = Resume.find_all_by_status("JOINED")
  joined_interviewer_hash = {}
  print_details(joined_resumes, "JOINED", joined_interviewer_hash, book)

  interviewer_hash = {}
  not_joined_interviewer_hash.each do |e, num|
    interviewer_hash[e] ||= [0, 0]
    interviewer_hash[e][0] = num
  end
  joined_interviewer_hash.each do |e, num|
    interviewer_hash[e] ||= [0, 0]
    interviewer_hash[e][1] = num
  end

  sheet = book.create_worksheet :name => "Interviewer Data"
  puts "\n\nInterviewer data \n\n"
  sheet.row(0).concat %w{Name NotJoined Joined}
  row = 1
  interviewer_hash.each do |e, arr|
    puts "#{e.name} \t #{arr[0]} #{arr[1]}"
    sheet.row(row).push e.name
    sheet.row(row).push arr[0]
    sheet.row(row).push arr[1]
    row += 1
  end
  book.write output


