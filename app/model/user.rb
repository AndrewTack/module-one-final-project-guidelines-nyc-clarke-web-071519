class User < ActiveRecord::Base
    has_many :matches

    has_many :followed_users, foreign_key: :follower_id, class_name: 'Match'
    has_many :followees, through: :followed_users
    
    has_many :following_users, foreign_key: :followee_id, class_name: 'Match'
    has_many :followers, through: :following_users

end