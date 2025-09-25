# lib/tasks/import_office_locations.rake
# rake import_office_locations

namespace :office_locations do
  desc "Import office locations from CSV file"
  task :import => :environment do
    require 'csv'
    
    csv_file_path = Rails.root.join('lib', 'office-locations.csv')
    
    unless File.exist?(csv_file_path)
      puts "❌ Error: CSV file not found at #{csv_file_path}"
      exit 1
    end
    
    puts "🚀 Starting import of office locations from #{csv_file_path}..."
    
    begin
      # Clear existing office locations (optional - remove if you want to keep existing data)
      # Officelocation.destroy_all
      # puts "🗑️  Cleared existing office locations"
      
      imported_count = 0
      skipped_count = 0
      error_count = 0
      
      CSV.foreach(csv_file_path, headers: true) do |row|
        # Skip empty rows
        next if row['Address'].blank? && row['City'].blank?
        
        # Generate a name from city and state
        city = row['City'].to_s.strip
        state = row['State'].to_s.strip
        
        if city.present?
          # Create a name like "BENGALURU-KARNATAKA" or just "BENGALURU" if no state
          name = state.present? ? "#{city.upcase}-#{state.upcase}" : city.upcase
        else
          # Fallback to address if no city
          name = row['Address'].to_s.strip[0..20] + "..."
        end
        
        # Check if location already exists
        existing_location = Officelocation.find_by(name: name)
        if existing_location
          puts "⏭️  Skipping existing location: #{name}"
          skipped_count += 1
          next
        end
        
        # Create new office location
        officelocation = Officelocation.new(
          name: name,
          address: row['Address'].to_s.strip,
          city: city,
          state: state,
          pincode: row['Pincode'].to_s.strip
        )
        
        if officelocation.save
          puts "✅ Created: #{name} - #{city}, #{state}"
          imported_count += 1
        else
          puts "❌ Failed to create #{name}: #{officelocation.errors.full_messages.join(', ')}"
          error_count += 1
        end
      end
      
      puts "\n📊 Import Summary:"
      puts "   ✅ Successfully imported: #{imported_count} locations"
      puts "   ⏭️  Skipped (already exist): #{skipped_count} locations"
      puts "   ❌ Errors: #{error_count} locations"
      puts "   📍 Total locations in database: #{Officelocation.count}"
      
    rescue => e
      puts "❌ Error during import: #{e.message}"
      puts e.backtrace.first(5).join("\n")
      exit 1
    end
  end
  
  desc "Clear all office locations"
  task :clear => :environment do
    count = Officelocation.count
    Officelocation.destroy_all
    puts "🗑️  Cleared #{count} office locations from database"
  end
  
  desc "Show all office locations"
  task :list => :environment do
    puts "📍 Office Locations in Database:"
    puts "=" * 50
    
    if Officelocation.count == 0
      puts "No office locations found."
    else
      Officelocation.order(:name).each do |location|
        puts "#{location.name}"
        puts "  Address: #{location.address}" if location.address.present?
        puts "  City: #{location.city}" if location.city.present?
        puts "  State: #{location.state}" if location.state.present?
        puts "  Pincode: #{location.pincode}" if location.pincode.present?
        puts "  Full Address: #{location.full_address}"
        puts "-" * 30
      end
    end
  end
end

# Main task that runs import
task :import_office_locations => 'office_locations:import'
