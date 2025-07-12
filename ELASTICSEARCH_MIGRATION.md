# Migration from Sphinx to Elasticsearch using Searchkick

This document outlines the migration from Thinking Sphinx to Elasticsearch using the Searchkick gem.

## Overview

The migration replaces Thinking Sphinx with Searchkick, which provides a simpler and more Rails-friendly way to integrate Elasticsearch.

## Changes Made

### 1. Gemfile Updates
- Commented out `thinking-sphinx` gem
- Added `searchkick` gem

### 2. Configuration Files
- Created `config/initializers/searchkick.rb` with Elasticsearch configuration

### 3. Model Updates
- Updated `app/models/resume.rb` to include Searchkick configuration
- Added `search_data` method to define indexed fields
- Added `should_index?` method for conditional indexing

### 4. Controller Updates
- Updated `app/controllers/home_controller.rb` to use Searchkick search syntax
- Modified both basic and advanced search methods

### 5. Rake Tasks
- Created `lib/tasks/searchkick_migration.rake` with migration tasks

## Migration Steps

### Prerequisites
1. Install Elasticsearch on your system
2. Ensure Elasticsearch is running on `localhost:9200` (or configure the URL in environment variables)

### Step 1: Install Dependencies
```bash
bundle install
```

### Step 2: Run Migration
```bash
# Full migration (recommended)
rake searchkick:full_migration

# Or run individual steps:
rake searchkick:migrate_from_sphinx
rake searchkick:cleanup_sphinx
```

### Step 3: Test the Migration
1. Restart your Rails application
2. Test search functionality in the UI
3. Verify that search results are returned correctly
4. Test advanced search with filters

### Step 4: Clean Up (Optional)
After confirming everything works:
1. Remove the commented `thinking-sphinx` line from Gemfile
2. Remove any remaining Sphinx configuration files
3. Update your deployment scripts if needed

## Configuration

### Environment Variables
Set these in your environment for production:

```bash
ELASTICSEARCH_URL=http://your-elasticsearch-host:9200
ELASTICSEARCH_USER=your_username
ELASTICSEARCH_PASSWORD=your_password
```

### Searchkick Configuration
The Searchkick configuration is in `config/initializers/searchkick.rb` and includes:
- Connection settings
- Index prefix for different environments
- Custom analyzer for better text search
- Timeout settings

## Search Features

### Basic Search
- Searches across: name, email, phone, qualification, location, summary, search_data, overall_status, related_requirements
- Name field is boosted (10x weight) for better relevance
- Supports word_start matching for partial searches

### Advanced Search
- Filters by: ctc, expected_ctc, exp_in_months, overall_status, related_requirements
- Range queries for numeric fields
- Exact matches for status and requirements

### Suggestions
- Provides search suggestions for: name, email, phone, qualification, location, summary

## Troubleshooting

### Common Issues

1. **Elasticsearch Connection Error**
   - Ensure Elasticsearch is running
   - Check the URL in `config/initializers/searchkick.rb`
   - Verify network connectivity

2. **Index Not Found**
   - Run `rake searchkick:reindex` to recreate the index
   - Check Elasticsearch logs for errors

3. **Search Not Working**
   - Verify the index exists: `curl localhost:9200/_cat/indices`
   - Check if data is indexed: `curl localhost:9200/recruitment_app_development_resumes/_search`

### Useful Commands

```bash
# Check Elasticsearch status
curl localhost:9200

# List all indices
curl localhost:9200/_cat/indices

# Search in Elasticsearch directly
curl -X GET "localhost:9200/recruitment_app_development_resumes/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "name": "john"
    }
  }
}'

# Reindex all resumes
rake searchkick:reindex

# Check Searchkick status
rails console
> Resume.searchkick_index.refresh
```

## Performance Considerations

1. **Indexing Performance**
   - Large datasets should be reindexed in batches
   - Consider using background jobs for reindexing in production

2. **Search Performance**
   - Use filters instead of queries when possible
   - Consider pagination for large result sets
   - Monitor query performance with Elasticsearch monitoring tools

3. **Memory Usage**
   - Monitor Elasticsearch memory usage
   - Adjust JVM heap size as needed

## Rollback Plan

If you need to rollback to Sphinx:

1. Restore the original Gemfile with `thinking-sphinx`
2. Restore the original `app/indices/resume_index.rb`
3. Restore the original controller search methods
4. Run `bundle install`
5. Restart the application

## Support

For issues with:
- **Searchkick**: Check the [Searchkick documentation](https://github.com/ankane/searchkick)
- **Elasticsearch**: Check the [Elasticsearch documentation](https://www.elastic.co/guide/index.html)
- **Rails integration**: Check the [Rails guides](https://guides.rubyonrails.org/) 