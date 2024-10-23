# frozen_string_literal: true

server '116.203.61.105', user: 'deploy', roles: ['app', 'db', 'web']

set :branch, 'dev'
set :rails_env, :production
set :application, 'solobooks'

set :keep_releases, 5

set :format, :pretty
set :log_level, :debug

set :default_env, {
  'SOLOBOOKS_DATABASE_PASSWORD' => ENV['SOLOBOOKS_DATABASE_PASSWORD'],
}
