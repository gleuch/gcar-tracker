require 'rubygems'
require 'sinatra'

root_dir = File.dirname(__FILE__)

set :environment, :production
set :root,    root_dir
set :app_file,  File.join(root_dir, 'share.rb')
disable :run

log = File.new(root_dir + "/log/production.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'track'
run Sinatra::Application
