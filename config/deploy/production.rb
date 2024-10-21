# frozen_string_literal: true

server '188.245.106.45', user: 'deploy', roles: ['app', 'db', 'web']

set :branch, 'main'
set :rails_env, :production
set :application, 'solobooks'

set :keep_releases, 5

set :format, :pretty
set :log_level, :debug
