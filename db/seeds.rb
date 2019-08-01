require 'faker'

User.destroy_all
Game.destroy_all
Usergame.destroy_all

25.times do 
    User.create(name: Faker::Name.first_name)
end

10.times do 
    greg.followers << User.all.sample
end 

5.times do
    Game.create
end

# create_pawns
    Game.all.each do |game|
        3.times do 
            Usergame.create(user_id: User.all.sample.id, game_id: game.id, player_role: "pawn")
        end 
    end 

# create_recievers
    Game.all.each do |game|
        Usergame.create(user_id: User.all.sample.id, game_id: game.id, player_role: "receivers")
    end

# create_creators
    Game.all.each do |game|
        Usergame.create(user_id: User.all.sample.id, game_id: game.id, player_role: "creator")
    end 