namespace :db do
  namespace :fixtures do

    desc 'Create YAML test fixtures from data in an existing database. Default is development database.'
    task :dump => :environment do
      sql = "SELECT * FROM %s"
      skip_table = ["schema_info"]

      desc 'Change ":development" if you want to override test/production databases'
      ActiveRecord::Base.establish_connection("#{RAILS_ENV}")
      (ActiveRecord::Base.connection.tables - skip_table).each do |table_name|
        i = "0000"
        File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
            "\n"
            hash["#{table_name}_#{i.succ!}"] = record
            hash
          }.to_yaml
        end
      end
    end
  end
end
