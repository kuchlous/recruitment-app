# lib/tasks/export_requirements.rake
# rake export_requirements.rake

task :export_requirements => :environment do
  require 'rubyXL' # For reading and writing existing XLSX files

  # Define the filename and path for the existing Excel file.
  # Ensure this file actually exists in your root directory before running the task.
  filename = 'job migration.xlsx'
  file_path = Rails.root.join(filename)

  # Check if the file exists before attempting to open it
  unless File.exist?(file_path)
    puts "Error: The file '#{file_path}' does not exist. Please ensure it's created first."
    exit 
  end

  puts "Opening existing Excel file: #{file_path}..."

  workbook = RubyXL::Parser.parse(file_path)

  worksheet = workbook[0] # Gets the first worksheet (index 0)

  # Fetch all Requirement records from the database.
  requirements = Requirement.all

  # Set the starting row for data.
  # Since headers are in row 0 (Excel row 1), we start data from row 1 (Excel row 2).
  row_num = 1 # This corresponds to Excel row 2

  # Iterate over each Requirement and write its data to the worksheet.
  requirements.each do |req|
    # Write req.id to Column A (column 0).
    worksheet.add_cell(row_num, 0, req.id)
    worksheet.add_cell(row_num, 1, req.name)     
    worksheet.add_cell(row_num, 2, req.description)
    worksheet.add_cell(row_num, 3, req.skill)
    # Column E (column 4) - Other Details
    # Column F (column 5) - Openings
    worksheet.add_cell(row_num, 5, req.nop)
    # Column G (column 6) - Location
    worksheet.add_cell(row_num, 6, 'Bengaluru') # TODO - Hardcoded for now as column doesn't exist in the model
    # Column H (column 7) - Min Work experience in years
    worksheet.add_cell(row_num, 7, (req.exp && req.exp.include?('-')) ? req.exp.split('-')[0].to_i : nil)
    # Column I (column 8) - Max Work experience in years
    worksheet.add_cell(row_num, 8, (req.exp && req.exp.include?('-')) ? req.exp.split('-')[1].to_i : nil)
    # Column J (column 9) - Min Work experience in months
    # Column K (column 10) - Max work experience in months
    # Column L (column 11) - Job Level
    # Column M (column 12) - Job Sourcer
    # Column N (column 13) - Recruiters
    worksheet.add_cell(row_num, 13, req.employee.email)
    # Column O (column 14) - Requester
    # Column P (column 15) - Hot Job
    worksheet.add_cell(row_num, 15, req.req_type == 'HOT' ? 'Y' : 'N')
    # Column Q (column 16) - Job Status
    worksheet.add_cell(row_num, 16, req.status)
    # Column R (column 17) - Business Unit
    # Column S (column 18) - Department
    # Column T (column 19) - Client
    # Column U (column 20) - Skill Type
    # Column V (column 21) - Primary Skills
    # Column W (column 22) - Secondary Skills
    # Column X (column 23) - Request Date
    # Column Y (column 24) - Recruitment Start Date
    # Column Z (column 25) - Joining Deadline
    # Column AA (column 26) - PS update date
    # Column AB (column 27) - IJP
    worksheet.add_cell(row_num, 27, 'Y') # TODO - Hardcoded for now as column doesn't exist in the model
    # Column AC (column 28) - Career site
    worksheet.add_cell(row_num, 28, 'N') # TODO - Hardcoded for now as column doesn't exist in the model
    # Column AD (column 29) - Show to Emp
    worksheet.add_cell(row_num, 29, 'Y') # TODO - Hardcoded for now as column doesn't exist in the model
    # Column AE (column 30) - EEO
    # Column AF (column 31) - Country
    worksheet.add_cell(row_num, 31, 'IND') # TODO - Hardcoded for now as column doesn't exist in the model
    # Column AG (column 32) - Job Modifictaion date
    # Column AH (column 33) - Management Comment
    # Column AI (column 34) - Employment type
    # Column AJ (column 35) - Work Mode
    # Column AK (column 36) - Salary Details
    # Column AL (column 37) - Educational Details
    # Column AM (column 38) - Educational Details (Global Hire)
    # Column AN (column 39) - Custom8
    # Column AO (column 40) - Group
    # Column AP (column 41) - Custom10
    # Column AQ (column 42) - Custom11
    # Column AR (column 43) - Custom12
    # Column AS (column 44) - Custom13
    # Column AT (column 45) - Custom14
    # Column AU (column 46) - Custom15
    # Column AV (column 47) - Custom16
    # Column AW (column 48) - Custom17
    # Column AX (column 49) - Custom18
    # Column AY (column 50) - Custom19
    # Column AZ (column 51) - Sub Domain
    # Column BA (column 52) - Custom21
    # Column BB (column 53) - Custom22
    # Column BC (column 54) - Rec Custom 1
    # Column BD (column 55) - Rec Custom 2
    # Column BE (column 56) - Rec Custom 3
    # Column BF (column 57) - Rec Custom 4
    # Column BG (column 58) - BU Head
    # Column BH (column 59) - TA Head
    worksheet.add_cell(row_num, 59, req.try(:ta_lead).try(:name))
    # Column BI (column 60) - Screening Panel
    # Column BJ (column 61) - Onboarding team member
    # Column BK (column 62) - Group head
    # Column BL (column 63) - Hiring Manager
    # Column BM (column 64) - TypeCustom7
    # Column BN (column 65) - TypeCustom8
    # Column BO (column 66) - TypeCustom9
    # Column BP (column 67) - TypeCustom10
    # Column BQ (column 68) - TypeCustom11
    # Column BR (column 69) - TypeCustom12
    # Column BS (column 70) - TypeCustom13
    # Column BT (column 71) - TypeCustom14
    # Column BU (column 72) - "Practice Head"
    # Column BV (column 73) - Job request type
    # Column BW (column 74) - Custom23
    # Column BX (column 75) - Office location
    # Column BY (column 76) - Custom25
    # Column BZ (column 77) - Custom26
    # Column CA (column 78) - Designation
    # Column CB (column 79) - Custom28
    # Column CC (column 80) - Custom29
    # Column CD (column 81) - Custom30
    # Column CE (column 82) - Custom31
    # Column CF (column 83) - Custom32
    # Column CG (column 84) - Custom33
    # Column CH (column 85) - Custom34
    # Column CI (column 86) - Custom35
    # Column CJ (column 87) - Custom36
    # Column CK (column 88) - Custom37
    # Column CL (column 89) - Custom38
    # Column CM (column 90) - Custom39
    # Column CN (column 91) - Custom40
    # Column CO (column 92) - Custom41
    # Column CP (column 93) - Custom42
    # Column CQ (column 94) - Custom43
    # Column CR (column 95) - Custom44
    # Column CS (column 96) - Custom45
    # Column CT (column 97) - Custom46
    # Column CU (column 98) - Custom47
    # Column CV (column 99) - Custom48
    # Column CW (column 100) - Custom49
    # Column CX (column 101) - Custom50
    # Column CY (column 102) - Custom51
    # Column CZ (column 103) - Custom52
    # Column DA (column 104) - Custom53
    # Column DB (column 105) - Custom54
    # Column DC (column 106) - Custom55
    # Column DD (column 107) - Custom56
    # Column DE (column 108) - Custom57
    # Column DF (column 109) - Custom58
    # Column DG (column 110) - Custom59
    # Column DH (column 111) - Custom60
    # Column DI (column 112) - Custom61
    # Column DJ (column 113) - Custom62
    # Column DK (column 114) - Custom63
    # Column DL (column 115) - Custom64
    # Column DM (column 116) - Custom65
    # Column DN (column 117) - Custom66
    # Column DO (column 118) - Custom67
    # Column DP (column 119) - Custom68
    # Column DQ (column 120) - Custom69
    # Column DR (column 121) - Custom70
    # Column DS (column 122) - Custom71
    # Column DT (column 123) - Custom72
    # Column DU (column 124) - Custom73
    # Column DV (column 125) - Custom74
    # Column DW (column 126) - Custom75
    # Column DX (column 127) - Custom76
    # Column DY (column 128) - Custom77
    # Column DZ (column 129) - Custom78
    # Column EA (column 130) - Custom79
    # Column EB (column 131) - Custom80

    row_num += 1
  end

  # Save the modified workbook back to the file.
  # This will overwrite the original 'job migration.xlsx' with the updated content.
  workbook.write(file_path)

  puts "Export and modification completed successfully! File saved to #{file_path}"
end
