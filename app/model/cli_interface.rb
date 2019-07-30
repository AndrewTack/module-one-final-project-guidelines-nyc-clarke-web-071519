require "sinatra/activerecord"
require 'pry'
require_relative './user.rb'



def model_test
    # users = User.all
    binding.pry
    puts 'hi'
end 

model_test


# require 'tty-prompt'
# @prompt = TTY::Prompt.new

# def login_or_signup
#     response = @prompt.select("Log In or Sign Up?", %w(LogIn SignUp))
#     if response == "LogIn"
#         login
#     else
#         signup
#     end
# end

# def login
#     login_response = @prompt.ask("What is your name")
#     if login_response 
#     end
#     binding.pry
#     puts 'hi'

# end

# def signup
#     signup_response = @prompt.ask("What is your name")
#     binding.pry
#     puts 'hi'
# end

# @current_user = login_or_signup




