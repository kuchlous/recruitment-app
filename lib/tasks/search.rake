desc 'This checks for ferret server by getting search results and restarts if search is empty'
task :check_ferret do |t, env|
  Rake::Task["environment"].invoke
  results = Resume.find_with_ferret("shyam ~")
  if (results.size == 0)
    puts "Restarting ferret server"
    `cd /var/www/html/recruitment/current; ./script/ferret_server --environment=production -R /var/www/html/recruitment/current start`
  end
end
