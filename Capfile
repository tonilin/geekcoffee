set :default_stage, "production"
set :stages, %w(staging production)
require 'capistrano/ext/multistage'



load 'deploy'
# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
load 'config/deploy'


Dir["config/recipes/*/*.rb"].each {|file| load file }