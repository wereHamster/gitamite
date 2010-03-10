# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gitamite_session',
  :secret      => 'b5bd7040ef347f573a1e65cf7f9b7b1d338a78ffa35f44692fbc99b244dcbe9d4962f3f34e089d61ad7bab8f58f327746649e9a64d35fbc00899daaa35dbec69'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
