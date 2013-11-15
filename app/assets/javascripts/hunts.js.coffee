# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

getHunts = ->
  #  Making the call to get all the hunts
  call = $.ajax('/hunts.json', {
      method: 'GET'
    })
  # After call is successful, the hunts are added to the hunt list on the index page
  call.done (data) ->
    # console.log data
    _.each data, (h) ->
      $('.huntList ul').prepend("<li data-role='#{h.role}' data-id='#{h.id}'>
        #{h.title}<br>
        #{h.role}<br>
        #{h.date}<br>
        </li>")


getLocations = (id) ->
# Populates the huntmasters hunt location view
  # thisHunt = $('.huntTabs').data('id')
  call = $.ajax("/hunts/#{id}", {
      method: 'GET'
    })

# After call is successful, the locations map is plotted
  call.done (data) ->
    thisHuntData = data
    role = "huntmaster"
    $('.huntMasterDisplay').prepend("<div class='map' id='huntMap'>Map</div>")
    $('.huntMasterDisplay').removeClass('display')
    makeMap(thisHuntData, role)

options = {
  enableHighAccuracy: true,
  timeout: 5000,
  maximumAge: 0
}

###### Declaring variables
# Current coordinates
crd = {}
currentLat = 0
currentLong = 0
currentHint = ''
currentClues = ''
currentAnswer = ''
currentClue = ''
status = false

# Function for checking the hunters distance from the clue location
getDistance = (currentLat, currentLong, crd) ->
  R = 6371
  d = Math.acos(Math.sin(currentLat)*Math.sin(crd.latitude) + Math.cos(currentLat)*Math.cos(crd.latitude) * Math.cos(crd.longitude-currentLong)) * R

# On a successful position check the current coordinates are stored and if distance is within the bounds of the clue location a text is sent to the user. also status is set to true to prevent texts from continually being sent
success = (pos) ->
  crd = pos.coords
  # console.log crd
  # console.log('Your current position is:')
  # console.log('Latitude : ' + crd.latitude)
  # console.log('Longitude: ' + crd.longitude)
  # console.log('More or less ' + crd.accuracy + ' meters.')
  dist = getDistance(currentLat, currentLong, crd)
  # Case when hunter is within the bounding box
  if dist < 100000 # 0.009144
    $('.answer').removeClass('display')
    # Sends a text to the user if they are within the bounding box and they havent received it yet
    # console.log status
    if status == false
      # Change status to true to prevent future texts from being sent
      status = true
      textcall = $.ajax("/send_texts/+14154076529/#{currentHint}", {
          method: 'GET'
        })

error = (err) ->
  console.warn('ERROR(' + err.code + '): ' + err.message)
# Checks the user's current position
getPosition = ->
  navigator.geolocation.getCurrentPosition(success, error, options)


# Storing the location coordinates for the current clue location, as well as its associated clues
clueLocation = (data, prog) ->
  _.find data.loc, (l) ->
    if l.order == prog
      currentLat = l.lat
      currentLong = l.long
      currentClues = l

# Storing the current clue, hint, and answer
getCluesInfo = (current) ->
  _.each current, (c) ->
    if c.answer != 'null'
      currentAnswer = c.answer
      currentClue = c.question
    else
      currentHint = c.question

# Creating a participant list
createParticipant = (data) ->
  entry = "<ul>"
  _.each data.name, (d) ->
    entry += "<li><p>#{d.name}</p></li>"
  entry += "</ul>"
  return entry

$ ->
  # Populating the index page with user-specific hunts
  getHunts()


  # When hunt is clicked it will display the proper view based on the user's role (hunter or huntmaster)
  # NOTE 'display' actually means 'hide'
  $('.huntList').on 'click', 'li', ->
    $('.indexView').addClass('display')
    hunt_id = $(this).data('id')
    if $(this).data('role') == 'hunter'
      $('.huntMasterView').addClass('display')
      $('.huntView').removeClass('display')
      $('.huntTabs').data('id', hunt_id)
    else
      $('.huntView').addClass('display')
      $('.huntMasterView').removeClass('display')
      $('.huntMasterTabs').data('id', hunt_id)

  # When "Add hunt" button is clicked it will display the huntmaster view (hunt details and locations)
  $('.addHunt').click ->
    $('.indexView').addClass('display')
    $('.huntMasterView').removeClass('display')
    $('.huntMasterTabs').removeData('id')
    $('.huntMasterDisplay').empty()


  # When "back" button is pressed, the index page is displayed.  NOTE 'display' actually means 'hide'
  $('.goBack').click ->
    if !($('.huntMasterView').hasClass('display'))
      $('.huntMasterView').addClass('display')
    if !($('.huntView').hasClass('display'))
      $('.huntView').addClass('display')
    if !($('.mapView').hasClass('display'))
      $('.mapView').addClass('display')
    if !($('.mapDisplay').hasClass('display'))
      $('.mapDisplay').addClass('display')
    $('.indexView').removeClass('display')
    $('.huntMasterDisplay').empty()
    $('.huntDisplay').empty()
    $('#coordinates ul').empty()

  #**** Huntmaster View ****
  #display hunt info
  $('.huntMasterTabs').on 'click', '.huntMasterNav', ->
    # grab the current tab to use in the callback
    currentTab = $(this)
    # clear the tab of previous data
    $('.huntMasterDisplay').empty()
    $('.mapView').addClass('display')
    $('#coordinates ul').empty()
    # if Hunt Details tab is clicked, show the Create Hunt form or the hunt details
    if currentTab.hasClass('huntMasterDetails')


      # If starting a new hunt, a create form will be displayed
      if !($('.huntMasterTabs').data('id'))
        entry = JST['templates/new_hunt']({})
        $('.huntMasterDisplay').prepend(entry)

        # when button is clicked display the form to add participants
        $('.add_participants').click ->
          event.preventDefault()
          $(this).hide()
          entry = JST['templates/add_participants']({})
          $('.hunter_list').prepend(entry)

          # populate the hunter_list in the create form
          $('.addParticipants').click ->
            event.preventDefault()
            # Grab the form value
            name = $('#participant_form').val()
            # Add name to the list
            $('.hunter_list').append("<li><p>#{name}</p></li>")
            # Clear the form value
            $('#participant_form').val('')
          # When done, the add participant form is removed and the add participant button is revealed
          $('.done').click ->
            event.preventDefault()
            $('#participants').remove()
            $('.add_participants').show()

        $('.createHunt').submit ->
          event.preventDefault()
          # Grabbing form values
          title = $('#huntTitle').val()
          start_location = $('#startLocation').val()
          start_time = $('#startTime').val()
          start_date = $('#startDate').val()
          end_time = $('#endTime').val()
          end_date = $('#endDate').val()
          description = $('#huntDescription').val()
          prize = $('#huntPrize').val()
          players = $('.hunter_list li')

          # Creating an object to pass into the create hunt ajax call
          hunt = {
            title: title,
            description: description,
            prize: prize,
            start_location: start_location,
            date: start_date + ' ' + start_time
            end: end_date + ' ' + end_time
          }
          # Ajax call to save the hunt
          call = $.ajax('/hunts', {
              method: 'POST',
              data: {
                hunt: hunt
              }
            })

          call.done (data) ->
            _.each players, (p) ->
              # Ajax call to get the user id that corresponds to the partipants username
              userCall = $.ajax("/user/#{p.textContent}", {
                  method: 'GET'
                })
              # After a successful call, use this user id and the hunt id to save to huntUser db
              userCall.done (user) ->
                # Creating object with participant info
                hunt_user = {
                        hunt_id: data.id,
                        user_id: user.id,
                        progress: '0',
                        role: 'hunter'
                      }
                # Making an ajax call to save participant entries to the db
                huntUserCall = $.ajax("/hunt_users/#{user.id}/confirm", {
                    method: 'POST'
                    data: {
                      hunt_user: hunt_user
                    }
                  })
            # Creating an object with current user info
            creater = {
                  hunt_id: data.id,
                  user_id: data.current_user,
                  role: 'huntmaster'
                }
            # Ajax call to save the current user as huntmaster in the hunt user db
            createrCall = $.ajax('/hunt_users', {
                method: 'POST',
                data: {
                    hunt_user: creater
                  }
              })
            # Removing the create hunt form
            $('.createHunt').remove()

            # Creating hunt details list and displaying it
            newEntry = JST['templates/hunt_master_display']({ data: data, clue: 0 })
            $('.huntMasterDisplay').prepend(newEntry)
            # Adding participant list
            $('.part').append(createParticipant(data))
            # Adding the newly created hunt_id to the huntmasterTab for referencing
            hunt_id = data.id
            $('.huntMasterTabs').data('id', hunt_id)
            # Add new hunt to the hunts list on the index page
            entry = JST['templates/newly_created_hunt']({ data: data })
            $('.huntList ul').prepend(entry)
      # If there is a current hunt id
      else
        # Grabbing the current hunt id
        id = $('.huntMasterTabs').data('id')
        # Do an ajax call to get the hunt details
        call = $.ajax("/hunts/#{id}", {
            method: 'GET'
          })
        # After the ajax call is complete, appending the details to huntMasterDisplay tab
        call.done (data) ->
          # Creating hunt details list and displaying it
          newEntry = JST['templates/hunt_master_display']({ data: data, clue: 0 })
          $('.huntMasterDisplay').prepend(newEntry)
          # Adding participant list
          $('.part').append(createParticipant(data))

    # If add locations is clicked, the map or an alert will show
    else if currentTab.hasClass('huntMasterClues')
      # If there is an current hunt id
      if $('.huntMasterTabs').data('id')
        $('.mapView').removeClass('display')
      # If there isnt a hunt id
      else
        alert('Sorry! You need to save a hunt before you can add locations.')
    # If hunt locations is clicked
    else
      $('.huntMasterDisplay').empty()
      if !($('.mapView').hasClass('display'))
        $('.mapView').addClass('display')
      id = $('.huntMasterTabs').data('id')
      getLocations(id)


  # Adding a location to a hunt
  $('.addLocation').submit ->
    event.preventDefault()
    # Grabbing the form values
    lat = $('#location_lat').val()
    long = $('#location_long').val()
    name = $('#location_name').val()
    question = $('#clueQuestion').val()
    answer = $('#clueAnswer').val()
    hint = $('clueHint').val()

    # Grabbing the current hunt id
    id = $('.huntMasterTabs').data('id')
    # Stores the number of locations
    nextLoc = ''
    # Ajax call to find the numbe of locations associated with the current hunt
    call = $.ajax("/locations/#{id}", {
        method: 'GET'
      })

    # After a successful it sets the nextLoc data equal to the next location number
    call.done (data) ->
      nextLoc = data.length + 1
      # Ajax call to save the location to the location db
      locationCall = $.ajax('/locations', {
          type: 'POST'
          data: {
            location: {
              lat: lat
              long: long
              name: name
            }
          }
        })

      # After a successful save, the id of the location is sent back
      locationCall.done (loc_data) ->
        # Hunt info object is created
        hunt_loc = {hunt_id: id, location_id: loc_data.id , loc_order: nextLoc}
        # Ajax call is made to save the hunt_id, loc_id, and loc_order to the huntLocation db
        huntLocCall = $.ajax("/hunt_locations", {
            type: 'POST',
            data: {
              hunt_loc: hunt_loc
            }
          })

        huntLocCall.done (hunt_loc_data) ->

        # Creating the clue info object
        clueInfo = {question: question, location_id: loc_data.id, answer: answer}
        # Ajax call is made to save the clue and answer to the db
        clueCall = $.ajax('/clues', {
            method: 'POST',
            data: {
              clue: clueInfo
            }
          })

        clueCall.done (clue_data) ->
        # Ajax call is made to save the hint to the db, with a null placeholder for the answer
        hintInfo = {question: question, location_id: loc_data.id, answer: 'null'}

        clueCall = $.ajax('/clues', {
            method: 'POST',
            data: {
              clue: hintInfo
            }
          })
        # Notifing the huntmaster that the clue was saved
        clueCall.done (clue_data) ->
          $('#coordinates ul').empty()
          $('#coordinates ul').prepend("<p>Location: #{loc_data.name} was saved successfully!</p>")
    # Clearing the form values
    $('#location_lat').val('')
    $('#location_long').val('')
    $('#location_name').val('')
    $('#clueQuestion').val('')
    $('#clueAnswer').val('')






  # Displaying the hunter view information
  $('.huntTabs').on 'click', '.huntNav', ->
    # Grab the current tab to use in the callback function
    currentTab = $(this)

    # Grab the id of the hunt for the ajax call
    id = $(this).parent().data('id')

    # Make the ajax call to get the hunt information
    # Display the hunt information after the ajax call is successful
    $.get("/hunts/#{id}").done (data) ->
      console.log data
      myDate = new Date()
      huntDate = new Date("#{data.date}")
      if huntDate < myDate && "#{data.current.progress}" >= 1
        # Checking the user's current location
        # Setting a timer to check the positon every 15 secs
        checkLocation = setInterval getPosition, 15000

      # Clear out any information that the hunt display is showing, so the new info can be shown
      $('.huntDisplay').empty()
      if !($('.mapDisplay').hasClass('display'))
        $('.mapDisplay').addClass('display')

      # Setting up the participant names as a list
      entry = createParticipant(data)

      # Setting up leaderboard
      # Sorting hunters by progress
      names = _.sortBy data.name, (p) ->
        -p.prog
      # Creating the list of hunters
      leaders = "<ul>"
      _.each names, (d) ->
        leaders += "<li><p>#{d.name}</p><p>#{d.prog}</p></li>"
      leaders += "</ul>"

      # Displaying the correct information based on which tab is currently active
      if currentTab.hasClass('huntDetails')
        newEntry = JST['templates/hunt_master_display']({ data: data })
        $('.huntDisplay').prepend(newEntry)
        # Adding participant list
        $('.part').append(entry)
        myDate = new Date()
        huntDate = new Date("#{data.date}")
        if huntDate < myDate && "#{data.current.progress}" < 1
          $('.huntDisplay').append('<button class="start">Start</button>')

        $('.start').click ->
          call = $.ajax("/hunt_users/#{id}", {
              method: 'PUT',
              data: {
                progress: '1'
              }
            })
          call.done (start_data) ->
            # Setting a timer to check the positon every 15 secs
            checkLocation = setInterval getPosition, 15000
          $(this).remove()


      else if currentTab.hasClass('huntClues')
        # Setting the current clue, answer, and hint based on the current hunters progress
        prog = parseInt(data.current.progress)

        clueLocation(data, prog)

        getCluesInfo(currentClues.clues)


        # Displaying the current clue
        $('.huntDisplay').prepend("<h4>Clue #{data.current.progress} of #{data.loc.length}</h4><br>
          <p>#{currentClue}</p><br>")
        # When answer is submitted, checking to see if hunter is correct
        $('.answer').submit ->
          event.preventDefault()
          ans = $('#answer').val()

          # if ans = the correct answer, progress needs to be updated to the db and the next clue needs to be revealed
          if ans == currentAnswer
            # If its the last location, the player wins, and it clear the check location function interval and text the hunters that someone won
            if prog == data.loc.length
              clearInterval(checkLocation)
            # If not the last location, then the users progress is saved
            else
              prog += 1
              call = $.ajax("/hunt_users/#{id}", {
                method: 'PUT',
                data: {
                  progress: "#{prog}"
                }
              })

              call.done (new_data) ->
              # Updating the next clue location
              clueLocation(data, prog)
              # Updating the current clue, hint and answer
              getCluesInfo(currentClues.clues)
              # Reset satus, so player will recieve texts for the next location
              status = false
              # Displaying the proper clue
              $('.huntDisplay h4').text("Clue #{prog} of #{data.loc.length}")
              $('.huntDisplay p').text("#{currentClue}")
              $('#answer').val('')


      else if currentTab.hasClass('huntMap')
        $('.huntDisplay').removeClass('display')
        $('.huntDisplay').prepend("<div class='map' id='huntMap'>Map</div>")
        #  Making the call to get all the locations for the specific hunt id
        thisHunt = $('.huntTabs').data('id')
        prog = parseInt(data.current.progress)
        call = $.ajax("/hunts/#{thisHunt}", {
          method: 'GET'
        })
      # After call is successful, the locations map is plotted
        call.done (data) ->
          thisHuntData = data
          role = "hunter"
          prog = prog
          makeMap(thisHuntData, role, prog)
          $('.huntDisplay').removeClass('display')
      else
        $('.huntDisplay').prepend("#{leaders}")














