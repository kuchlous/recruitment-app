desc 'This generates interview XL sheet'
require 'spreadsheet'

def create_xls_sheet_and_get_matches(for_status, req_id)
    requirement                 = Requirement.find(req_id)
    Spreadsheet.client_encoding = 'UTF-8'
    book                        = Spreadsheet::Workbook.new
    sheet                       = book.create_worksheet :name => for_status
    output                      = "#{RAILS_ROOT}/tmp/requirement_"  + for_status.downcase + "_status_#{requirement.name.gsub(/[& -\/\\]/, '_')}.xls"
    unless for_status == "JOINING"
      req_forwards              = requirement.forwards
      req_forwards              += requirement.req_matches
      forwards                  = req_forwards.find_all { |f| f.status     == for_status }
    else
      req_forwards              = requirement.req_matches
      forwards                  = req_forwards
    end
    [ sheet, book, output, forwards ]
end

def fill_forwarded_shortlisted_data(sheet, forwards)
    sheet.row(0).concat %w{Name Education Current\ Company Exp Req Email Phone\ Number Referral}
    blue = Spreadsheet::Format.new :weight => :bold,
                                   :size   => 12
    sheet.column(0).width = 30
    sheet.column(1).width = 50
    sheet.column(2).width = 50
    sheet.column(3).width = 30
    sheet.column(4).width = 30
    sheet.column(5).width = 30
    sheet.column(6).width = 30

    sheet.row(0).default_format = blue
    row = 1
    forwards.each do |fwd|
      sheet.row(row).height = 20
      resume = fwd.resume
      sheet.row(row).push Spreadsheet::Link.new "xx"
      sheet.row(row).push resume.qualification
      sheet.row(row).push resume.current_company
      sheet.row(row).push resume.experience
      if (fwd.class == Forward) 
        req_names = nil
        fwd.requirements.each do |r|
          if req_names.nil?
            req_names = r.name
          else
            req_names += ", #{r.name}"
          end
        end
        sheet.row(row).push req_names
      else
        sheet.row(row).push fwd.requirement.name
      end
      sheet.row(row).push resume.email
      sheet.row(row).push resume.phone
      sheet.row(row).push resume.referral_name
      row += 1 
    end
end

task :reject_xls do |t, env|
  Rake::Task["environment"].invoke
  req_name = "DFT-BLR/HYD"
  status = "HOLD"
  req_id = Requirement.find_by_name(req_name)
  sheet, book, output, rejected_matches = create_xls_sheet_and_get_matches(status, req_id)
  fill_forwarded_shortlisted_data(sheet, rejected_matches)
  book.write output
  puts "Wrote in file #{output}"
  system "echo \"#{status} Resumes for #{req_name}\" | mail -a #{output} -s \"XL file for #{status} resumes for #{req_name}\" alokk@mirafra.com"
end

