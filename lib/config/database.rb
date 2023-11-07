require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: ENV["DB_HOST"] || 'localhost',
  username: ENV["DB_USER"] || 'my_user',
  password: ENV["DB_PASS"] || 'my_password',
  database: ENV["DB_NAME"] || 'my_db'
)