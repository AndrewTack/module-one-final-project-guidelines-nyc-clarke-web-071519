class User < ActiveRecord::Base
    has_many :followed_users, foreign_key: :follower_id, class_name: 'Match'
    has_many :followees, through: :followed_users
    
    has_many :following_users, foreign_key: :followee_id, class_name: 'Match'
    has_many :followers, through: :following_users

    has_many :usergames
    has_many :games, through: :usergames


    # #Create gameboard
    # def create_new_game
    #     Game.new
    #     Usergame.new(self.id, ?????????, "creator")
    # end

    # #Send gameboard
    # def send_gameboard(friend)
    #     Usergame.new(friend, ?????????, "receivers")
    # end

    # #View received gameboards
    # def view_receieved_gameboards
    #     self.usergames.select {|game| game.player_role == "receiver"}
    # end

    # #Choose gameboard to play
    # def choose_gameboard #(user_input)
    #     games_list = self.usergames.all {|usergame| puts usergame}
    #     puts "Hey #{self.name}! Welcome to Break Mode. Which of your games would you like to play?"
    #     user_input = gets.chomp
    #     games_list.find do |games| 
    #         if games == user_input
    #             games
    #         else
    #             puts "Couldn't find this game. Please choose from your list of available games!"
    #         end
    #     end
    # end

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



    # # def created_games ##    that haven't been played yet
    # #     created_user_games = self.usergames.select {|game| game.player_role == "creator"}
    #     #   games = create_user_games.map {|usergame| usergame.game}
    #     #   find_users_for_each_game = games.map {|game| game.users}
    # # end

    # # def received_games
    # #     self.usergames.select {|game| game.player_role == "receiver"}
    # # end

    # #view my matches
    # def view_my_matches
    #     self.matches.select {|match| match.follower_id == self.id || match.followee_id == self.id}
    # end

    # #view options tab
    # def view_options(user_input)
    #     options =   "
    #         1) 

    #                     "
    #     if user_input == "Options"
    #         puts options
    #     end
    # end
    
    #exit game --- does this need a method?
    


end