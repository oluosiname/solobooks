# frozen_string_literal: true

set :application, 'solobooks'
set :repo_url, 'git@github.com:oluosiname/solobooks.git'
set :deploy_to, '/var/www/solobooks'

set :rvm_type, :user # Use :user for RVM installed for a single user, :system for system-wide RVM
set :rvm_ruby_version, 'ruby-3.2.2' # Specify the Ruby version you want to use with RVM

# Ensure Capistrano doesn't ask for a password when running sudo
set :pty, true

# Linked files and directories
# set :linked_files, ['config/database.yml', '.env']
# set :linked_dirs, ['log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system']

if ENV['LOCAL_DEPLOYMENT']
  set :ssh_options, {
    forward_agent: true,
    user: 'deploy',
    keys: ['~/.ssh/id_rsa_solobooks'], # Local SSH key path for local deployment
    auth_methods: ['publickey'],
  }
end

# Restart Puma after deployment
after 'deploy:publishing', 'puma:restart'
