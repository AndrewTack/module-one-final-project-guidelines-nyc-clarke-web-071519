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

def create_new_game
    current_game = Game.create
    Usergame.create(user_id: @current_user.id, game_id: current_game.id, player_role: "creator")
  
    # Add Receiver to Gameboard
    name_array = User.where("name != ?", @current_user.name).pluck(:name)
    single_response = @prompt.select("Choose someone you're interested in to receive this gameboard.", name_array)
    receiver_instance = User.all.find_by(name: single_response)
    Usergame.create(user_id: receiver_instance.id, game_id: current_game.id, player_role: "receiver")
   
    # Add Pawns to Gameboard
    #Want to have more specific selection process here...
        #Select your competition. Who do you want #{single_response} choosing between? Pick at least 1 competitor or at most 3.
    #Once a receiver is selected, they shouldn't be a pawn option...
        #think this one is working now
    pawn_name_array = name_array.delete(receiver_instance.name)
    selection_response = @prompt.multi_select("Select your competition.", name_array)
    selection_response.each do |user_name|
        pawn_id = User.all.find_by(name: user_name) 
        Usergame.create(user_id: pawn_id.id, game_id: current_game.id, player_role: "pawn")
    end

    #Now that this board has been created. Send this board.
    send_board = @prompt.yes?("Are you ready to send this gameboard?")
    if send_board 
        #need to actually send board?
        #Usergame.create(user_id: @current_user.id, game_id: current_game.id, player_role: "creator")
        puts "Gameboard sent! Hopefully the ice will be broken with #{single_response}. Check back in your My Matches soon."
        sent_but_unplayed
    else
        puts "No need to chicken out! If #{single_response} doesn't break the ice, they won't even know it was you that sent this board."
        are_you_sure = @prompt.yes?("Are you sure you don't want to send this board?")
            if are_you_sure
                main_menu
            else 
                puts "Gameboard sent! Hopefully the ice will be broken with #{single_response}. Check back in your My Matches soon."
                sent_but_unplayed
            end
    end
end

def play_gameboard

    #View number of received gameboards 
    received_gameboards = @current_user.view_receieved_gameboards
    if received_gameboards.length > 0
    ready_to_play = @prompt.yes?("You have #{received_gameboards.length} games to play. Are you ready to play your next game?")  
        if ready_to_play

            #Get a list of users associated with this game
            specific_game = received_gameboards[0].game
            #game_name_array = specific_game.users.map {|user| user.name} THIS IS OLD, was giving our player a gameboard with themselves in it
            game_name_array = specific_game.users.where("name != ?", @current_user.name).pluck(:name)
            gameboard = @prompt.select("Who are you most interested in?", game_name_array)
                #with the select above, does gameboard == a value(name in the form of a string) or a just a boolean (like with select.yes?)?
            
                #if MATCH --- if selected == creator 
                this_games_creator = specific_game.usergames.find_by(player_role: "creator")

                if gameboard == this_games_creator.user.name
                    
                    puts "It's a Match!"
                    
                    #create an instance of a match...
                    # creator_id = Usergame.all.find_by(player_role: "creator") #for this specific game_id though
                    # Match.create(follower_id: creator_id, followee_id: @current_user.id)
                
                    #delete one Game from database (not usergame), rerun method to update count
                    #dependent destroy. method added to belongs_to/has_many
                    specific_game.destroy 

                    #view_my_matches

                else

                    puts "No Match! Thanks for playing."
                
                    #delete one Game from database (not usergame), rerun method to update count
                    #dependent destroy. method added to belongs_to/has_many
                    specific_game.destroy

                    go_back = @prompt.keypress("Press any key when you're ready to return to Main Menu")
                    main_menu
                end



        else 
            main_menu
        end
    else
        puts "No Gameboards to play yet!"
    end

    go_back = @prompt.keypress("Press any key when you're ready to return to Main Menu")
    main_menu

end

def sent_but_unplayed
    sent_gameboards_count = @current_user.view_created_gameboards.length

    if sent_gameboards_count > 0
        @prompt.keypress("You've sent #{sent_gameboards_count} games that are yet to be played. Don't worry, they'll be played soon! \n Press any key to return to the Main Menu.")  
        main_menu
    else 
        puts "You've sent #{sent_gameboards_count} games that are yet to be played."
        go_back = @prompt.keypress("Press any key when you're ready to return to Main Menu")
        main_menu
    end

    #delete one Game from database (not usergame), rerun method to update count
    #game.destroy 

end

def log_out
    puts "Thanks for playing!"
    exit
end

login_or_signup
