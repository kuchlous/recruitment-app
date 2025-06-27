# lib/tasks/export_candidates.rake
# rake export_candidates.rake

task :export_candidates => :environment do
  require 'rubyXL' # For reading and writing existing XLSX files

  # Define the filename and path for the existing Excel file.
  # Ensure this file actually exists in your root directory before running the task.
  filename = 'candidate migration.xlsx'
  file_path = Rails.root.join(filename)

  # Check if the file exists before attempting to open it
  unless File.exist?(file_path)
    puts "Error: The file '#{file_path}' does not exist. Please ensure it's created first."
    exit 
  end

  puts "Opening existing Excel file: #{file_path}..."

  workbook = RubyXL::Parser.parse(file_path)

  worksheet = workbook[0] # Gets the first worksheet (index 0)

  # Fetch all Requirement Matches records from the database.
  req_matches = ReqMatch.all

  # Set the starting row for data.
  # Since headers are in row 0 (Excel row 1), we start data from row 1 (Excel row 2).
  row_num = 1 # This corresponds to Excel row 2

  # Iterate over each Requirement and write its data to the worksheet.
  req_matches.each do |req_match|
    resume = req_match.resume
    requirement = req_match.requirement
    
    # Column A (column 0) - salutation
    # Column B (column 1) - first name
    worksheet.add_cell(row_num, 1, resume.name) # first name is same as name as we don't have a separate field for it
    # Column C (column 2) - middle name
    # Column D (column 3) - last name
    worksheet.add_cell(row_num, 3, resume.name) # last name is same as name as we don't have a separate field for it
    # Column E (column 4) - email
    worksheet.add_cell(row_num, 4, resume.email)
    # Column F (column 5) - job cd
    worksheet.add_cell(row_num, 5, requirement.id)
    # Column G (column 6) - phone
    # Mandatory, no special characters, only 10 digit number allowed
    worksheet.add_cell(row_num, 6,(resume.phone =~ /\A\d{10}\z/ ? resume.phone.to_i : nil))
    # Column H (column 7) - pan number
    # Column I (column 8) - date
    # Column J (column 9) - month
    # Column K (column 10) - year
    # Column L (column 11) - apply date
    # Column M (column 12) - round
    worksheet.add_cell(row_num, 12, map_stage_desc_to_code(req_match.status))
    # Column N (column 13) - sub-round
    # Column O (column 14) - joining date
    worksheet.add_cell(row_num, 14, resume.joining_date ? resume.joining_date.strftime('%d/%m/%Y') : nil)
    # Column P (column 15) - source
    # Column Q (column 16) - subsource
    # Column R (column 17) - referred by
    worksheet.add_cell(row_num, 17, resume.referral_name)
    # Column S (column 18) - candidate Id
    worksheet.add_cell(row_num, 18, resume.id)
    # Column T (column 19) - application Id
    worksheet.add_cell(row_num, 19, resume.file_name)
    # Column U (column 20) - employee Id
    # Column V (column 21) - custom1
    # Column W (column 22) - custom2
    # Column X (column 23) - custom3
    # Column Y (column 24) - custom4
    # Column Z (column 25) - custom5
    # Column AA (column 26) - custom6
    # Column AB (column 27) - custom7
    # Column AC (column 28) - custom8
    # Column AD (column 29) - custom9
    # Column AE (column 30) - custom10
    # Column AF (column 31) - custom11
    # Column AG (column 32) - custom12
    # Column AH (column 33) - custom13
    # Column AI (column 34) - custom14
    # Column AJ (column 35) - custom15
    # Column AK (column 36) - custom16
    # Column AL (column 37) - custom17
    # Column AM (column 38) - custom18
    # Column AN (column 39) - custom19
    # Column AO (column 40) - custom20
    # Column AP (column 41) - custom21
    # Column AQ (column 42) - custom22
    # Column AR (column 43) - custom23
    # Column AS (column 44) - custom24
    # Column AT (column 45) - custom25
    # Column AU (column 46) - custom26
    # Column AV (column 47) - custom27
    # Column AW (column 48) - custom28
    # Column AX (column 49) - custom29
    # Column AY (column 50) - custom30
    # Column AZ (column 51) - custom31
    # Column BA (column 52) - custom32
    # Column BB (column 53) - custom33
    # Column BC (column 54) - custom34
    # Column BD (column 55) - custom35
    # Column BE (column 56) - custom36
    # Column BF (column 57) - custom37
    # Column BG (column 58) - custom38
    # Column BH (column 59) - custom39
    # Column BI (column 60) - custom40
    # Column BJ (column 61) - custom41
    # Column BK (column 62) - custom42
    # Column BL (column 63) - custom43
    # Column BM (column 64) - custom44
    # Column BN (column 65) - custom45
    row_num += 1
  end

  # Save the modified workbook back to the file.
  # This will overwrite the original 'candidate migration.xlsx' with the updated content.
  workbook.write(file_path)

  puts "Export and modification completed successfully! File saved to #{file_path}"
end

def map_stage_desc_to_code(stage_desc)
  # Convert the input stage_desc to uppercase for case-insensitive matching
  upcased_stage_desc = stage_desc.to_s.upcase

  case upcased_stage_desc
  when 'LEAD' then 'Suggested'
  when 'REJECTED' then 'Rejected'
  when 'ON HOLD' then 'On Hold'
  when 'HIRED' then 'Hired'
  when 'JOINING PAGE' then 'Onboarding'
  when 'OFFERED' then 'Offered'
  when 'YTO' then 'HR stage'
  when 'INTERVIEW 2' then 'Interview 2'
  when 'INTERVIEW 1' then 'Interview 1'
  when 'SHORTLISTED' then 'Shortlisted'
  when 'APPLIED' then 'Applied'
  when 'INTERVIEW 3' then 'Interview 3'
  when 'INTERVIEW 4' then 'Interview 4'
  when 'EHD' then 'Engineering Hiring Decision Trigger'
  when 'MHD' then 'Management Hiring Decision Trigger'
  when 'PRE OFFER' then 'Pre Offer'
  when 'NOT JOINED' then 'Not Hired'
  when 'NOT OFFERED' then 'Not Offered'
  when 'EHD HAC' then 'EHD HAC'
  when 'MHD HAC' then 'MHD HAC'
  else 'Applied' # Default value if no match is found
  end
end