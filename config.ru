require 'rubygems'
require 'sinatra'

ROOT_DIR = File.expand_path(File.dirname(__FILE__))

Sinatra::Application.set(
:run         => false,
:environment => :production
)

log = File.new("log/sinatra.log", "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

APP_ROOT = "#{File.dirname(__FILE__)}/"
require 'application.rb'
run Sinatra::Application
