# Advanced Monkey patch for Searchkick::IndexOptions#index_options method
# This provides more granular control over index options customization

module Searchkick
  class IndexOptions
    Rails.logger.info "Searchkick IndexOptions#index_options"
    # Store the original method using instance_method to avoid circular reference
    original_method = instance_method(:index_options)
    
    # Override the index_options method with advanced customization
    define_method :index_options do
      # Check if monkey patch is enabled
      unless MonkeyPatchConfig::ENABLE_MONKEY_PATCH
        return original_method.bind(self).call
      end
      
      # Call the original method to get the base options
      original_options = original_method.bind(self).call
      
      customize_mappings(original_options[:mappings]) if original_options[:mappings]
      
      # Log the final options for debugging (optional)
      if MonkeyPatchConfig::DEBUG_LOGGING
        Rails.logger.debug "Searchkick Index Options: #{original_options.inspect}"
      end
      
      # Return the modified options
      original_options
    end

    private

    def customize_mappings(mappings)
      return unless mappings[:properties]

      # Remove ignore_above from integer and float fields
      mappings[:properties].each do |field_name, field_config|
        if field_config.is_a?(Hash) && (field_config[:type] == "integer" || field_config[:type] == "float")
          field_config.delete(:ignore_above)
        end
      end
    end
  end
end 