class AddEmployeeNames < ActiveRecord::Base
  # Appends employee names to localdata.js file lied in jquery_autocomplete directory

  # Collecting all employees
  employees = Employee.all

  # First file in reading mode
  contents_of_file = IO.readlines(RAILS_ROOT + "/public/javascripts/localdata.js")

  # Second file in writing mode
  File.open(RAILS_ROOT + "/public/javascripts/temp_localdata.js", "w+") do |fh|
    for line in contents_of_file
      if (/(empNames\[\"listedEmployees\"\])/).match(line)
        fh.write 'empNames["listedEmployees"] = ['
        for emp in employees
          fh.write ' "' + emp.name.to_s + '",'
        end
        fh.write ' ];'
      else
        fh.write line.to_s
      end
    end
    fh.close
  end
  # Renaming second file to first one
  File.rename(RAILS_ROOT + "/public/javascripts/temp_localdata.js", RAILS_ROOT + "/public/javascripts/localdata.js")
end
