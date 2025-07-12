# Searchkick Monkey Patch Configuration
# This file controls the behavior of the Searchkick monkey patches

module Searchkick
  module MonkeyPatchConfig
    # Enable/disable the monkey patch
    ENABLE_MONKEY_PATCH = true
    
    # Enable debug logging
    DEBUG_LOGGING = Rails.env.development?

  end
end 