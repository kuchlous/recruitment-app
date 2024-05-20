# To run this rake task execute below command
# rails resumes:extract_skills
namespace :resumes do
    desc 'Extract skills from old Resumes.'
    task :extract_skills => :environment do
        connection = Faraday.new(APP_CONFIG['resume_parsr_svc']) do |f|
            f.request :multipart
            f.request :url_encoded
            f.adapter :net_http
        end
        puts "Extracting skills from Resumes.."
        Resume.all.each do |resume|
            puts "Resume Name: #{resume.name}"
            path = resume.resume_path[0] if resume.resume_path.length > 0 rescue nil
            content_type = path.split(".")[-1] rescue nil
            filename = resume.file_name rescue nil
            if (path.present? and content_type.present? and filename.present?)
              file = Faraday::UploadIO.new(
                path,
                content_type,
                filename
              )
              payload = {:resume => file}
              puts "Sending request to service..."
              response = connection.post('/parse_resume', payload)
              if response.success?
                response_body = JSON.parse(response.body)
                skills = response_body["skills"]
                if skills.present?
                    puts "Updating record with Skills: #{skills}."
                    resume.update_attributes(skills: skills) 
                end
              end
            else
                puts "Skipping as required details are not present for the resume..."
            end
        end
    end
end