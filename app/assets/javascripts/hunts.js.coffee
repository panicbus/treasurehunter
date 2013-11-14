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
#     # Cycling through the list of locs
#     _.each data, (locs) ->
#       clue = ''
#       hint = ''
#       answer = ''
#       # Assigning the hint, clue, and answer variables
#       _.each locs.clues, (c) ->
#         if c.answer == 'null'
#           hint = c.question
#         else
#           clue = c.question
#           answer = c.answer
#       # Adding the loc to the list with its clues
#       $('.huntMasterDisplay').prepend(
#           "<li class='showClues' data-id='#{locs.id}'>
#             <h5>#{locs.name}</h5>
#             <ul class='clueList display'>
#               <p>Clue: #{clue}</p>
#               <p>Hint: #{hint}</p>
#               <p>answer: #{answer}</p>
#             </ul>
#           </li>"
#         )

#     # Toggling the showing of the clues for each loc
#     $('.showClues').click ->
#       if ($(this).children().last().hasClass('display'))
#         $(this).children().last().removeClass('display')
#       else
#         $(this).children().last().addClass('display')
# Sets options for the position search
options = {
  enableHighAccuracy: true,
  timeout: 5000,
  maximumAge: 0
}

# Declaring the current coordinate variables
crd = {}
currentLat = 0
currentLong = 0
status = false
getDistance = (currentLat, currentLong, crd) ->
  R = 6371
  d = Math.acos(Math.sin(currentLat)*Math.sin(crd.latitude) + Math.cos(currentLat)*Math.cos(crd.latitude) * Math.cos(crd.longitude-currentLong)) * R

success = (pos) ->
  crd = pos.coords
  console.log crd
  console.log('Your current position is:')
  console.log('Latitude : ' + crd.latitude)
  console.log('Longitude: ' + crd.longitude)
  console.log('More or less ' + crd.accuracy + ' meters.')
  dist = getDistance(currentLat, currentLong, crd)
  if dist < 1000 # 0.009144
    $('.answer').removeClass('display')
    # phone_number = {phone_number: '4154076529', body: 'test'}
    if status == false
      textcall = $.ajax("/send_texts/", {
          method: 'POST',
          data: {
            phone_number: "+14158893434"
          }
        })

error = (err) ->
  console.warn('ERROR(' + err.code + '): ' + err.message)
# Checks the user's current position
getPosition = ->
  navigator.geolocation.getCurrentPosition(success, error, options)
# Setting a timer to check the positon every 15 secs
checkLocation = setInterval getPosition, 15000

$ ->
  # Populating the index page with user-specific hunts
  getHunts()
  # getPosition()


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
        $('.huntMasterDisplay').prepend("<form class='createHunt'>
          <h3>Create a hunt!</h3>
          Title: <input type='text' id='huntTitle'><br>
          Description: <input type='text' id='huntDescription'><br>
          Start Date: <input type='date' id='startDate'><br>
          Start Time: <input type='time' id='startTime'><br>
          Start Location: <input type='text' id='startLocation'><br>
          Prize: <input type='text' id='huntPrize'><br>
          <button class='add_participants'>Add Participants</button>
          <ul class='hunter_list'></ul>
          <input type='submit' value='Save Hunt'>
          </form>")

        # when button is clicked display the form to add participants
        $('.add_participants').click ->
          event.preventDefault()
          $(this).hide()
          $('.hunter_list').prepend("<form id='participants'>
            <h4>Add a Hunter</h4>
            Name: <input type='text' id='participant_form' name='name'><br>
            <button class='addParticipants'>Add Participant</button>
            <button class='done'>Done</button>
            </form>")

          # populate the hunter_list in the create form
          $('.addParticipants').click ->
            event.preventDefault()
            # Grab the form value
            name = $('#participant_form').val()
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
                        progress: '1',
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
            # Appending the newly created hunt with details
            # Creating a list of the participants
            entry = "<ul>"
            _.each players, (p) ->
              entry += "<li><p>#{p.textContent}</p></li>"
            entry += "</ul>"
            $('.huntMasterDisplay').prepend("<ul class='details'>
              <h3>Hunt Details</h3>
              <li><h5>Hunt Title:  </h5><p>#{data.title}</p></li>
              <li><h5>Hunt Description:  </h5><p>#{data.description}</p></li>
              <li><h5>Hunt Prize:  </h5><p>#{data.prize}</p></li>
              <li><h5>Start on:  </h5><p>#{data.date}</p></li>
              <li><h5>Start Location:  </h5><p>#{data.start_location}</p></li>
              <li><h5>Number of Clues:  </h5><p>0</p></li>
              <li><h5>Participants:  </h5>#{entry}</li>
            </ul>")
            # Adding the newly created hunt_id to the huntmasterTab for referencing
            hunt_id = data.id
            $('.huntMasterTabs').data('id', hunt_id)
            # Add new hunt to the hunts list on the index page
            $('.huntList ul').prepend("<li data-role='huntmaster' data-id='#{data.id}'>
              #{data.title}<br>
              huntMaster<br>
              #{data.date}<br>
              </li>")

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
          # Setting up the participant names as a list
          entry = "<ul>"
          _.each data.name, (d) ->
            entry += "<li><p>#{d.name}</p></li>"
          entry += "</ul>"
          $('.huntMasterDisplay').prepend("<ul class='details'>
              <h3>Hunt Details</h3>
              <li><h5>Hunt Title:  </h5><p>#{data.title}</p></li>
              <li><h5>Hunt Description:  </h5><p>#{data.description}</p></li>
              <li><h5>Hunt Prize:  </h5><p>#{data.prize}</p></li>
              <li><h5>Start on:  </h5><p>#{data.date}</p></li>
              <li><h5>Start Location:  </h5><p>#{data.start_location}</p></li>
              <li><h5>Number of Clues:  </h5><p>#{data.loc.length}</p></li>
              <li><h5>Participants:  </h5>#{entry}</li>
            </ul>")
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
    console.log crd
    # Grab the id of the hunt for the ajax call
    id = $(this).parent().data('id')
    # console.log id
    # Make the ajax call to get the hunt information
    call = $.ajax("/hunts/#{id}", {
        method: 'GET'
      })


    # Display the hunt information after the ajax call is successful
    call.done (data) ->
      myDate = new Date()
      huntDate = new Date("#{data.date}")
      if huntDate < myDate && "#{data.current.progress}" >= 1
        # Checking the user's current location
        checkLocation

      # Clear out any information that the hunt display is showing, so the new info can be shown
      $('.huntDisplay').empty()
      if !($('.mapDisplay').hasClass('display'))
        $('.mapDisplay').addClass('display')
      # console.log data
      # Setting up the participant names as a list
      entry = "<ul>"
      _.each data.name, (d) ->
        entry += "<li><p>#{d.name}</p></li>"
      entry += "</ul>"

      # Setting up leaderboard
      leaders = "<ul>"
      _.each data.name, (d) ->
        leaders += "<li><p>#{d.name}</p><p>#{d.prog}</p></li>"
      leaders += "</ul>"

      # Displaying the correct information based on which tab is currently active
      if currentTab.hasClass('huntDetails')
        $('.huntDisplay').prepend("<ul class='details'>
            <h3>Hunt Details</h3>
            <li><h5>Hunt Title:  </h5><p>#{data.title}</p></li>
            <li><h5>Hunt Description:  </h5><p>#{data.description}</p></li>
            <li><h5>Hunt Prize:  </h5><p>#{data.prize}</p></li>
            <li><h5>Start on:  </h5><p>#{data.date}</p></li>
            <li><h5>Start Location:  </h5><p>#{data.start_location}</p></li>
            <li><h5>Number of Clues:  </h5><p>#{data.loc.length}</p></li>
            <li><h5>Participants:  </h5>#{entry}</li>
          </ul>")
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
            checkLocation
          $(this).remove()


      else if currentTab.hasClass('huntClues')
        # Setting the current clue, answer, and hint based on the current hunters progress
        prog = parseInt(data.current.progress)

        currentClues = _.find data.loc, (l) ->
          if l.order == prog
            currentLat = l.lat
            currentLong = l.long
            return l

        currentAnswer = ''
        currentHint = ''
        currentClue = ''

        _.find currentClues.clues, (c) ->
          if c.answer != 'null'
            # console.log c.answer
            currentAnswer = c.answer
            currentClue = c.question
          else
            currentHint = c.question
        # Displaying the current clue
        $('.huntDisplay').prepend("<h4>Clue #{data.current.progress} of #{data.loc.length}</h4><br>
          <p>#{currentClue}</p><br>")
        # When answer is submitted, checking to see if hunter is correct
        $('.answer').submit ->
          event.preventDefault()
          ans = $('#answer').val()

          # if ans = the correct answer, progress needs to be updated to the db and the next clue needs to be revealed
          if ans == currentAnswer
            console.log true
            prog += 1
            call = $.ajax("/hunt_users/#{id}", {
              method: 'PUT',
              data: {
                progress: "#{prog}"
              }
            })

            call.done (new_data) ->

            currentClues = _.find data.loc, (l) ->
              if l.order == prog
                return l
            currentAnswer = ''
            currentHint = ''
            currentClue = ''
            _.find currentClues.clues, (c) ->
              if c.answer != 'null'
                console.log c.answer
                currentAnswer = c.answer
                currentClue = c.question
              else
                currentHint = c.question
            # console.log currentClue
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














