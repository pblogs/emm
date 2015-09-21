require 'factory_girl_rails'

DatabaseCleaner.strategy = :truncation, { except: %w(public.schema_migrations) }
DatabaseCleaner.clean
FileUtils.rm_rf('public/uploads/.')
puts 'DB and Uploads cleared'
