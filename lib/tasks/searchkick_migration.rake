namespace :searchkick do
  desc "Migrate from Sphinx to Elasticsearch using Searchkick"
  task migrate_from_sphinx: :environment do
    puts "Starting migration from Sphinx to Elasticsearch..."
    
    # Reindex all resumes
    puts "Reindexing all resumes..."
    Resume.reindex
    
    puts "Migration completed successfully!"
    puts "You can now remove the thinking-sphinx gem and related configurations."
  end

  desc "Reindex all resumes"
  task reindex: :environment do
    puts "Reindexing all resumes..."
    Resume.reindex
    puts "Reindex completed!"
  end

  desc "Clean up old Sphinx indices"
  task cleanup_sphinx: :environment do
    puts "Cleaning up old Sphinx indices..."
    
    # Remove Sphinx index file
    sphinx_index_file = Rails.root.join('app', 'indices', 'resume_index.rb')
    if File.exist?(sphinx_index_file)
      File.delete(sphinx_index_file)
      puts "Removed #{sphinx_index_file}"
    end
    
    # Remove Sphinx configuration files if they exist
    sphinx_config_files = [
      Rails.root.join('config', 'sphinx.yml'),
      Rails.root.join('config', 'thinking_sphinx.yml')
    ]
    
    sphinx_config_files.each do |file|
      if File.exist?(file)
        File.delete(file)
        puts "Removed #{file}"
      end
    end
    
    puts "Sphinx cleanup completed!"
  end

  desc "Full migration: migrate data, cleanup sphinx, and update gemfile"
  task full_migration: :environment do
    puts "Starting full migration from Sphinx to Elasticsearch..."
    
    # Step 1: Migrate data
    Rake::Task['searchkick:migrate_from_sphinx'].invoke
    
    # Step 2: Cleanup Sphinx
    Rake::Task['searchkick:cleanup_sphinx'].invoke
    
    puts "Full migration completed!"
    puts "Next steps:"
    puts "1. Run 'bundle install' to install searchkick gem"
    puts "2. Remove thinking-sphinx gem from Gemfile"
    puts "3. Restart your application"
    puts "4. Test search functionality"
  end
end 