# set :environment, 'staging'

set :output, { error: 'log/error.log', standard: 'log/cron.log' }

every :day, at: '3:00am' do
  rake 'vimeo_videos:clear_needless'
end
