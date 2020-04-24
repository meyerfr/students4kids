# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts('create Users')
User.create(email: 'fritz.schack@code.berlin', first_name: 'Fritz', last_name: 'Schack', password: 'fritzSchack', role: 'admin')
User.create(email: 'fritz.meyer@code.berlin', first_name: 'Fritz', last_name: 'Meyer', password: 'fritzMeyer', role: 'admin')
User.create(email: 'Adam@Ali', first_name: 'Adam', last_name: 'Ali', password: 'adamAli', role: 'sitter')
User.create(email: 'Ben@Bauer', first_name: 'Ben', last_name: 'Bauer', password: 'benBauer', role: 'sitter')
User.create(email: 'Claudia@Corona', first_name: 'Claudia', last_name: 'Corona', password: 'claudiaCorona', role: 'parent')
User.create(email: 'Dirk@Dauer', first_name: 'Dirk', last_name: 'Dauer', password: 'dirkDauer', role: 'parent')
