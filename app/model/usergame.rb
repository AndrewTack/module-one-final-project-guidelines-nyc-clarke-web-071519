class Usergame < ActiveRecord::Base

    belongs_to :user 
    belongs_to :game #, dependent: destroy

end