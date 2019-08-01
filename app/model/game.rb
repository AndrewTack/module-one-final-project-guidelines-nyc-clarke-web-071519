class Game < ActiveRecord::Base
    
   has_many :usergames, dependent: :destroy
   has_many :users, through: :usergames

end