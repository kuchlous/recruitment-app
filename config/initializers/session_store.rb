# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_recruitment_session',
  :secret      => 'f67df2e5f0a85103e63a9da53406dd3579e83c4c06f4a9933942b0c9dfef490f3d90fdeb7dc161475b60ef4490cdd3c50c08d6314d69650c7a00d602a569b291'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
