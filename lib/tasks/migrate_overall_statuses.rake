namespace :overall_status do
  OLD_TO_NEW = {
    "Joining Date Given" => "JOINING",
    "Offered"            => "OFFERED",
    "Yet To Offer"       => "YTO",
    "HAC"                => "HAC",
    "Engg. Select"       => "ENG_SELECT",
    "On Hold"            => "HOLD",
    "Interview Scheduled"=> "SCHEDULED",
    "Shortlisted"        => "SHORTLISTED",
    "Forwarded"          => "FORWARDED",
    "Rejected"           => "REJECTED",
    "New"                => "NEW",
    # Also normalize values derived from resume.status
    "Joined"             => "JOINED",
    "Not Joined"         => "NOT JOINED",
    "Future"             => "FUTURE",
    "N Accepted"         => "N_ACCEPTED"
  }.freeze

  desc "Preview how many resumes will be updated for each overall_status mapping"
  task preview: :environment do
    puts "Previewing overall_status migration (old => new => count)"
    pending = 0
    OLD_TO_NEW.each do |old_value, new_value|
      count = Resume.where(overall_status: old_value).count
      pending += count
      puts "%20s  =>  %-12s  | %5d" % [old_value, new_value, count]
    end
    puts "\nTotal to update: #{pending}"
  end

  desc "Migrate overall_status values from old display strings to new short codes"
  task migrate: :environment do
    puts "Starting overall_status migration..."
    total_updated = 0

    ActiveRecord::Base.transaction do
      OLD_TO_NEW.each do |old_value, new_value|
        scope = Resume.where(overall_status: old_value)
        count = scope.count
        if count > 0
          scope.update_all(overall_status: new_value, updated_at: Time.current)
          total_updated += count
          puts "Updated %-20s -> %-12s | %5d" % [old_value, new_value, count]
        else
          puts "No rows for %-20s (skipping)" % old_value
        end
      end
    end

    puts "\nMigration complete. Total rows updated: #{total_updated}"
  end
end


