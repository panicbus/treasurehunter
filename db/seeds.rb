# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    users = User.create([
        {username: 'James', email: 'jamestreasurehunter@gmail.com', password: '12345678'},
        {username: 'Jennie', email: 'j@gmail.com', password: '12345678'},
        {username: 'Leon', email: 'leontreasurehunter@gmail.com', password: '12345678'}
      ])

    hunt_users = HuntUser.create([

      ])

