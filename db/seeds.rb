# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

r1 = Role.create({name: "Admin", description: "Can perform any CRUD operation on any resource"})
r2 = Role.create({name: "Regular", description: "Can read resources"})

u1 = User.create({first_name: "Alok", last_name: "Anand", email: "alokanand02@gmail.com", password: "test1234", password_confirmation: "test1234", role_id: r1.id})
u2 = User.create({first_name: "Regular", last_name: "User", email: "regular.user@example.com", password: "test1234", password_confirmation: "test1234", role_id: r2.id})
