# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{emmortal@159.203.81.203}
role :web, %w{emmortal@159.203.81.203}
role :db,  %w{emmortal@159.203.81.203}

set :rvm_ruby_version, '2.2.2@emmortal'
set :rvm_type, :user

set :branch, :development

set :rails_env, 'staging'

set :unicorn_rack_env, 'staging'
set :unicorn_config_path, -> { File.join(current_path, 'config', 'unicorn', 'staging.rb') }

set :deploy_to, '/home/emmortal/www/emmortal'

set :whenever_environment, 'staging'

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '159.203.81.203', user: 'emmortal', roles: %w{web}

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
