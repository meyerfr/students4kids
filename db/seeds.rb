# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# require 'faker'

puts('create Users')
User.create(email: 'fritz.schack@code.berlin', first_name: 'Fritz', last_name: 'Schack', password: 'fritzSchack', role: 'admin')
User.create(email: 'fritz.meyer@code.berlin', first_name: 'Fritz', last_name: 'Meyer', password: 'fritzMeyer', role: 'admin')
User.create(email: 'Adam@Ali', first_name: 'Adam', last_name: 'Ali', password: 'adamAli', role: 'sitter')
User.create(email: 'Ben@Bauer', first_name: 'Ben', last_name: 'Bauer', password: 'benBauer', role: 'sitter')
User.create(email: 'Claudia@Corona', first_name: 'Claudia', last_name: 'Corona', password: 'claudiaCorona', role: 'parent')
User.create(email: 'Dirk@Dauer', first_name: 'Dirk', last_name: 'Dauer', password: 'dirkDauer', role: 'parent')
# User.create(email: 'Erik@Eiermann', first_name: 'Erik', last_name: 'Eiermann', password: 'erikEiermann', role: 'pa')
# User.create(email: 'Felix@Fuchs', first_name: 'Felix', last_name: 'Fuchs', password: 'felixFuchs', role: 'sitter', address: 'address: "858 Hickle Shoal, Parisianburg')

puts 'Add Fake Address to all Users'
User.all.each do |user|
  user.update(
    address: "#{Faker::Address.street_address}", #=> "282 Kevin Brook, Imogeneborough, CA 58517"
    radius: rand(2..10)
  )
end
puts 'Finished!'

Availability.create(start_time: Time.parse("#{Date.tomorrow} 10"), end_time: Time.parse("#{Date.tomorrow} 17"), sitter_id: 3, status: 'available')
Availability.create(start_time: Time.parse("#{Date.tomorrow+1.day} 10"), end_time: Time.parse("#{Date.tomorrow+1.day} 17"), sitter_id: 3, status: 'available')
Availability.create(start_time: Time.parse("#{Date.tomorrow+2.day} 10"), end_time: Time.parse("#{Date.tomorrow+2.day} 17"), sitter_id: 3, status: 'available')
Availability.create(start_time: Time.parse("#{Date.tomorrow+3.day} 10"), end_time: Time.parse("#{Date.tomorrow+3.day} 17"), sitter_id: 3, status: 'available')
