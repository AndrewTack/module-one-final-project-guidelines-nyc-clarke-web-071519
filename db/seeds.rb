require 'faker'

User.destroy_all

# user_names = ["Greg", "Varun", "Andrew"]

# user_names.each do |user_name|
#     User.create(name: user_name)
# end

25.times do 
    User.create(name: Faker::Name.first_name)
end



