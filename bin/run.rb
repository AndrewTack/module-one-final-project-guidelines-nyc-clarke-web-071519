require_relative '../config/environment'

require "bundler/setup"

require "sinatra/activerecord"
require 'ostruct'
require 'date'

Bundler.require

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}

# connection_details = YAML::load(File.open('config/database.yml'))
# ActiveRecord::Base.establish_connection(connection_details)




puts "Welcome to Ice Breaker!"
# figure out how to add 2 second pause 
puts "Are you interested in dating a Friend, but aren't sure how to break the ice?"
# figure out how to add 2 second pause
puts "We're here to help. All you have to do Create and Send a GameBoard to this friend.
    If PRONOUN is interested in connecting, Ice Breaker will break the ice!"


