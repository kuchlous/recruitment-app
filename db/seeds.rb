# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Employee.create ({name:"Anwesha", eid: 1, login: "anwesha", email: "engg.anwesha@gmail.com", manager_id: 100, employee_type: "SW", employee_status: "ACTIVE"})
Employee.create ({name:"Subhrajit", eid: 2, login: "subhrajit", email: "subzero@gmail.com", manager_id: 100, employee_type: "SW", employee_status: "ACTIVE"})
Employee.create ({name:"Alok", eid: 2, login: "alokk", email: "alokk@gmail.com",is_admin:true, employee_type: "SW", employee_status: "ACTIVE"})