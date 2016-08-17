namespace :db do
  namespace :database do
    desc 'This rake task is used to execute for another rake tasks.'
    task :clear, :arg1, :arg2 do |t, env|
      # Database migration
      `rake db:migrate RAILS_ENV="#{env.arg1}"`
      puts "Started executing rake tasks in recruitment system"

      # For dumping the fixtures data into database
      `rake db:fixtures:load`

      # For testing we need to create a test directory in resumes directory
#      if env.arg1 == "test"
#        `mkdir resumes/test`
#      end
      puts "Ending executing rake tasks in recruitment system"
    end
  end
end
