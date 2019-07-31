require_relative '../../config/environment.rb'
require "sinatra/activerecord"
require 'pry'
require_relative './user.rb'
require_relative './game.rb'
require_relative './match.rb'
require_relative './usergame.rb'

require 'tty-prompt'
@prompt = TTY::Prompt.new
@current_user = nil

#view matches
def view_my_matches
    if @current_user.matches.length > 0
        @current_user.matches.each {|match| puts match.name}
    else
        puts "No Matches yet!"
    end

    go_back = @prompt.keypress("Press any key when you're ready to return to Main Menu")
    main_menu

end 

def main_menu
    main = @prompt.select("Choose an Option", ["Create A GameBoard", "Play A GameBoard", "My Matches", "My Sent but Unplayed Gameboards", "Log Out"])
    if main == "Create A GameBoard"
        create_new_game
    elsif main == "Play A GameBoard"
        play_gameboard
    elsif main == "My Matches"
        view_my_matches
    elsif main == "My Sent but Unplayed Gameboards"
        sent_but_unplayed
    elsif main == "Log Out"
        log_out
    end
end 

def login_or_signup
    response = @prompt.select("Log In or Sign Up?", %w(LogIn SignUp))
    if response == "LogIn"
        login
    else
        signup
    end
end

def login
    login_response = @prompt.ask("What is your name")
    if User.find_by(name: login_response)
        @current_user = User.find_by(name: login_response)
        main_menu
    else
        puts "Your username wasn't found. Please try again."
        sleep 2
        login_or_signup
    end
end

def signup
    signup_response = @prompt.ask("What is your name")
    @current_user = User.create(name: signup_response)
    main_menu
end

 #Create gameboard
    #how do I shift all of this over with fancy buttons?
    def create_new_game
            current_game = Game.create
            Usergame.create(user_id: @current_user.id, game_id: current_game.id, player_role: "creator")

            # Add Pawns to gameboard
            name_array = User.all.map {|user| user.name}
            #want to have more specific selection process here...
            #Select your competition. Who do you want #{single_response} choosing between? Pick at least 1 competitor or at most 3.
            selection_response = @prompt.multi_select("Select your competition.", name_array)
            selection_response.each do |user_name| 
                pawn_id = User.all.find_by(name: user_name)
                Usergame.create(user_id: pawn_id.id, game_id: current_game.id, player_role: "pawn")
            end

            # Add Receiver to gameboard
            # To bump this to before selecting competition... just move above?
            single_response = @prompt.select("Choose a receiver.", name_array)
            receiver_id = User.all.find_by(name: single_response)
            Usergame.create(user_id: receiver_id.id, game_id: current_game.id, player_role: "receiver")

            #Now that this board has been created. Send this board?
            send_board = @prompt.yes?("Are you ready to send this gameboard?")
            if send_board
                puts "Gameboard sent! Hopefully the ice will be broken with #{single_response}. Check back in your My Matches soon."
                sent_but_unplayed
            else
                puts "No need to chicken out! If #{single_response} doesn't break the ice, they won't even know it was you that sent this board."
                #@prompt.yes?("Are you sure you don't want to send this board?")
                    #if no
                        #main_menu
                    #end
            end
    end

    def play_gameboard

        #View number received gameboards 
        received_gameboards = @current_user.view_receieved_gameboards
        @prompt.yes?("You have #{received_gameboards} games to play. Are you ready to play your next game?")  
        #if yes... play
        #if no... @prompt.yes?("Back to Main Menu?")
            #if yes... main_menu
            #if no back to original prompt

        #usergame.game.users to get a list of all users associated with this game. 
        #then can prompt to play this game

        #delete one from count ... received_gameboards -= 1
    end

    def sent_but_unplayed
        sent_gameboards = @current_user.view_created_gameboards
        @prompt.keypress("You've sent #{sent_gameboards} games that are yet to be played. Don't worry, they'll be played soon! \n Press any key to return to the Main Menu.")  
        main_menu
        
        #delete one from count ... sent_gameboards -= 1
    end

    def log_out
        puts "Thanks for playing!"
        exit
    end

    # #play_game
    # def play_game(choose_gameboard)
    #     puts "Let's Break the Ice! Which of these people are you most interested in connecting with?"
    #     user_input = gets.chomp
    #     puts "You've selected #{user_input}! Is this your final answer?"
    #     #Yes/No prompt?
    #     if self.name == user_input
    #         Match.new
    #         puts "It's a Match!"
    #     else 
    #         puts "No Match! Thanks for playing."
    #     end
    #     # delete game
    #     #back to main menu...
    # end

    # #delete game
    # def delete_game(choose_gameboard)
    #     delete_current_game = self.usergames.all.delete(choose_gameboard)
    # end

login_or_signup
