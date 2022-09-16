User.create!(name: "Example User",
    email: "example@railstutorial.org",
    phone: "0985879454",
    address: "My Tho, Tien Giang, Viet Nam",
    password: "foobar",
    password_confirmation: "foobar",
    activated: true,
    activated_at: Time.zone.now)

25.times do |n|
    name = "Trunk Lee"
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name: name,
    email: email,
    phone: "0985879454",
    address: "My Tho, Tien Giang, Viet Nam",
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(15)
users.each{
    |user|
    description = "Nike, Inc. is an American multinational corporation that is engaged in the design, development, manufacturing, and worldwide marketing and sales of footwear, apparel, equipment, accessories, and services"
    avatar = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Nike_Flagship_-_NYC_%2848155560636%29.jpg/270px-Nike_Flagship_-_NYC_%2848155560636%29.jpg"
    Shop.create!(name: "Tiki", description: description, avatar: avatar, user_id: user.id )
}

# shops = Shop.order(:created_at).take(3)
# 5.times do
#     description = "Designed by Bruce Kilgore and introduced in 1982, the Air Force 1 was the first ever basketball shoe to feature Nike Air technology, revolutionizing the game and sneaker culture forever"
#     shops.each{
#         |shop|
#         for i in 0...3 do
#             if i%2 == 0
#                 image = "nike1.png"
#             else
#                 image = "nike2.png"
#             end
#             shop.products.create!(name: "Nike air force 1", color: "Red", size:"XXL",
#                 price: 15000, quantity_remain: 5, description: description, image: image)
#         end
# }
# end

cates = ["Lifestyle", "Jordan", "Running", "Basketball", "Football", "Training & Gym", "Skateboarding", "Golf", "Tennis",
        "Athletics", "Walking"]
cates.each do |cate|
    Category.create!(name: cate)
end

sizes = ["X", "M", "L", 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48]
sizes.each do |size|
    Size.create!(name: size)
end

# Create following relationships.
users = User.all
user = users.first
following = users[2..10]
followers = users[3..15]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
