# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_helper_session',
  :secret      => 'e97d330c20c0f1898f8591018bc4986c9d46c9120637e1698ba58cb69ac3497eb633239ae6087e8dd7c7e576ae1aaff141b9debf0e49767b74c0f252a52337bc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
