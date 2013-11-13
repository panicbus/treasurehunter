# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

    users = User.create([
        {username: 'James', email: 'jamestreasurehunter@gmail.com', password: '12345678'},
        {username: 'Jennie', email: 'k@k.com', password: '12345678'},
        {username: 'Leon', email: 'leontreasurehunter@gmail.com', password: '12345678'},
        {username: 'Nico', email: 'n@n.com', password: '12345678'},
        {username: 'Feather', email: 'f@f.com', password: '12345678'}
      ])


    huntlocs = HuntLocation.create([
        {hunt_id: 1, location_id: 1, loc_order: 1},
        {hunt_id: 1, location_id: 2, loc_order: 2},
        {hunt_id: 1, location_id: 3, loc_order: 3},
        {hunt_id: 1, location_id: 4, loc_order: 4},
        {hunt_id: 2, location_id: 1, loc_order: 1},
        {hunt_id: 2, location_id: 2, loc_order: 2},
        {hunt_id: 2, location_id: 3, loc_order: 3},
        {hunt_id: 2, location_id: 4, loc_order: 4},
        {hunt_id: 2, location_id: 5, loc_order: 5}
      ])

    clues = Clue.create([
        {location_id: 1, question: 'why', answer: 'I dunno'},
        {location_id: 2, question: 'how', answer: 'Dont ask me'},
        {location_id: 3, question: 'who', answer: 'the butler'},
        {location_id: 4, question: 'what', answer: 'chicken butt'},
        {location_id: 5, question: 'where', answer: 'GA'}
      ])

    locations = Location.create([
        {lat: 37.7798756, long:-122.39492960000001, name: 'fun'},
        {lat: 37.800766757533154, long: -122.40900583291017, name: 'chili'},
        {lat:37.79398456172312 , long: -122.47973032021486, name: 'funk'},
        {lat: 37.73916158196152, long: -122.50032968544923, name: 'eat'},
        {lat: 37.69570860158703, long: -122.40763254189454, name: 'monkey'}
      ])

    hunts = Hunt.create([
        {title: 'SOMA Hunt', description: 'Starts at GA and includes AT&T Park', prize: 'Willie Mays glove', date: 'Dec 1, ', start_location: 'new york'},
        {title: 'North Beach Hunt', description: 'Includes Columbus St', prize: 'Sign at Grant & Green', date: 'Dec 15', start_location: 'GA'},
      ])

    hunt_users = HuntUser.create([
        {hunt_id: 1, user_id: 1, role: 'hunter', progress: 2},
        {hunt_id: 1, user_id: 2, role: 'hunter', progress: 3},
        {hunt_id: 1, user_id: 3, role: 'hunter', progress: 6},
        {hunt_id: 1, user_id: 4, role: 'huntmaster', progress: 6},
        {hunt_id: 2, user_id: 4, role: 'hunter', progress: 7},
        {hunt_id: 2, user_id: 5, role: 'hunter', progress: 9},
        {hunt_id: 2, user_id: 3, role: 'hunter', progress: 7},
        {hunt_id: 2, user_id: 1, role: 'huntmaster', progress: 2},
      ])

