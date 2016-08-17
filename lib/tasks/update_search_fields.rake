desc 'This updates the search fields in the resume'
task :update_search_fields do |t, env|
  Rake::Task["environment"].invoke
  Resume.all.each do |r|
    puts "Processing #{r.name}"
    r.update_search_fields
  end
end
