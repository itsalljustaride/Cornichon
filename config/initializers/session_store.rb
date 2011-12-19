# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cornichon_session',
  :secret      => 'c75068959c189defe5c49371d2cc5cd331bbe5691cf11bced5f73f700eaee0b2f7275f2348730df6ed287ea88eed2575f3c0613cf01fb3b621fc1b3fc3d5b1e4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
