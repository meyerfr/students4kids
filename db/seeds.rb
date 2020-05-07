# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require 'faker'

puts('delete all Users')
User.destroy_all

puts('create Admins')
User.create(email: 'fritz.schack@code.berlin', first_name: 'Fritz', last_name: 'Schack', password: 'fritzSchack', role: 'admin')
User.create(email: 'fritz.meyer@code.berlin', first_name: 'Fritz', last_name: 'Meyer', password: 'fritzMeyer', role: 'admin')
# User.create(email: 'Erik@Eiermann', first_name: 'Erik', last_name: 'Eiermann', password: 'erikEiermann', role: 'pa')
# User.create(email: 'Felix@Fuchs', first_name: 'Felix', last_name: 'Fuchs', password: 'felixFuchs', role: 'sitter', address: 'address: "858 Hickle Shoal, Parisianburg')

u = User.create(email: 'adam@Adam.com', first_name: 'Adam', last_name: 'Adam', password: 'adamAdam', role: 'sitter')
u.availabilities.create(start_time: Time.parse("#{Date.tomorrow} 8"), end_time: Time.parse("#{Date.tomorrow} 22"))
User.create(email: 'berta@berta.com', first_name: 'Berta', last_name: 'Berta', password: 'bertaBerta', role: 'parent')
# Berlins latitude range 52.3700..52.5700
# Berlins longitude range 13.2650..13.5050

puts 'Create Users and associated availabilities or children'
100.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  u = User.create(
    first_name: first_name,
    last_name: last_name,
    password: "#{first_name}#{last_name}",
    email: "#{first_name.downcase}@#{last_name.downcase}.com",
    dob: Date.today - rand(7_000..25_000),
    phone: rand(10_000_000_000).to_s,
    role: %w(sitter parent).sample,
    latitude: rand(52.3700..52.5700).round(4),
    longitude: rand(13.2650..13.5050).round(4),
    radius: rand(3..10),
    bio: Faker::Lorem.paragraph(sentence_count: 4)
  )

  if u.role == 'sitter'
    # create availabilities of sitter
    start_time = Time.parse("#{Date.tomorrow + rand(70)} #{rand(10..16)}")
    end_time = start_time + rand(3..6).hours
    u.availabilities.create!(start_time: start_time, end_time: end_time)
  else
    # create children of parent
    rand(1..4).times do
      u.children.create(
        first_name: Faker::Name.first_name,
        dob: Date.today - rand(5_000)
      )
    end
  end
end

puts 'Finished!'
