desc 'This generates interview XL sheet'
require 'spreadsheet'
require 'time'
task :generate_interview_sheet do |t, env|
  Rake::Task["environment"].invoke
  start_date = Date.today
  end_date = Date.today
  Spreadsheet.client_encoding = 'UTF-8'
  output                      = "#{RAILS_ROOT}/tmp/my_interviews_#{Date.today.day}_#{Date.today.month}.xls"
  book                        = Spreadsheet::Workbook.new
  results = Interview.find(:all, :conditions => [ "interview_date >= '#{start_date}' AND interview_date <= '#{end_date}'"])
  sheet = book.create_worksheet :name => "Interviews"
  row = 1
  sheet.row(row).push(["Name", "Requirement"]) 
#  results.each do |r|
#    row += 1;
#    sheet.row(row).push([r.req_match.resume.name, r.req_match.requirement.name])
#  end
  book.write output
end
