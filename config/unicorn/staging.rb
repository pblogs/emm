# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/home/emmortal/www/emmortal/current"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/home/emmortal/www/emmortal/current/tmp/pids/unicorn.pid"

# Path to logs
stderr_path "/home/emmortal/www/emmortal/current/log/unicorn.log"
stdout_path "/home/emmortal/www/emmortal/current/log/unicorn.log"

# Unicorn socket
#listen "/tmp/unicorn.[app name].sock"
listen "/home/emmortal/www/emmortal/shared/unicorn.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
