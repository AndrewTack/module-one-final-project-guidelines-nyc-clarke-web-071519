class User < ActiveRecord::Base
    
    has_many :followed_users, foreign_key: :follower_id, class_name: 'Match'
    has_many :followees, through: :followed_users
    
    has_many :following_users, foreign_key: :followee_id, class_name: 'Match'
    has_many :followers, through: :following_users

    has_many :usergames
    has_many :games, through: :usergames

    def matches
        my_matches = []
        my_matches << self.followees
        my_matches << self.followers
        my_matches.flatten.uniq
    end

    #View received gameboards
    def view_receieved_gameboards
        #list of games where user is the "receiver"
        received_gameboards_array = self.usergames.select {|game| game.player_role == "receiver"}
    end

    #View created gameboards
    def view_created_gameboards
        #list of games where user is the "creator"
        created_gameboards_array = self.usergames.select {|game| game.player_role == "creator"}
    end

end