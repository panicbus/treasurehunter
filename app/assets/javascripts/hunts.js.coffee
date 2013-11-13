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
    console.log data
    _.each data, (h) ->
      $('.huntList ul').prepend("<li data-role='#{h.role}' data-id='#{h.id}'>
        #{h.title}<br>
        #{h.role}<br>
        #{h.date}<br>
        </li>")

$ ->
  # Populating the index page with users hunts
  getHunts()

  # When hunt is clicked it will display the proper view, either hunter or huntmaster
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

  # When new hunt button is clicked it will display the huntmaster view
  $('.addHunt').click ->
    $('.indexView').addClass('display')
    $('.huntMasterView').removeClass('display')
    $('.huntMasterTabs').removeData('id')
    $('.huntMasterDisplay').empty()


  # When back button is pressed, the index page is displayed
  $('.goBack').click ->
    if !($('.huntMasterView').hasClass('display'))
      $('.huntMasterView').addClass('display')
    if !($('.huntView').hasClass('display'))
      $('.huntView').addClass('display')
    if !($('.mapView').hasClass('display'))
      $('.mapView').addClass('display')
    $('.indexView').removeClass('display')
    $('.huntMasterDisplay').empty()
    $('.huntDisplay').empty()

  #**** Huntmaster View ****
  #display hunt info
  $('.huntMasterTabs').on 'click', '.huntMasterNav', ->
    # grab the current tab to use in the callback
    currentTab = $(this)
    # clear the tab of previous data
    $('.huntMasterDisplay').empty()
    $('.mapView').addClass('display')
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
            date: start_date + start_time
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
                huntUserCall = $.ajax('/hunt_users', {
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
    # If hunt locations is clicked, the map or an alert will show
    else
      # If there is an current hunt id
      if $('.huntMasterTabs').data('id')
        $('.mapView').removeClass('display')
      # If there isnt a hunt id
      else
        alert('Sorry! You need to save a hunt before you can add locations.')



  # Adding a location to a hunt
  $('.addLocation').submit ->
    event.preventDefault()
    # Grabbing the form values
    lat = $('#location_lat').val()
    long = $('#location_long').val()

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
            }
          }
        })
      # After a successful save, the id of the location is sent back, and an ajax call is made to save the hunt_id, loc_id, and loc_order to the huntLocation db
      locationCall.done (data) ->
        hunt_loc = {hunt_id: id, location_id: data.id , loc_order: nextLoc}

        huntLocCall = $.ajax("/hunt_locations", {
            type: 'POST',
            data: {
              hunt_loc: hunt_loc
            }
          })



  # Displaying the hunter view information
  $('.huntTabs').on 'click', '.huntNav', ->
    # Grab the current tab to use in the callback function
    currentTab = $(this)

    # Grab the id of the hunt for the ajax call
    id = $(this).parent().data('id')
    console.log id
    # Make the ajax call to get the hunt information
    call = $.ajax("/hunts/#{id}", {
        method: 'GET'
      })


    # Display the hunt information after the ajax call is successful
    call.done (data) ->
      # Clear out any information that the hunt display is showing, so the new info can be shown
      $('.huntDisplay').empty()

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
            <li><h5>Start Location:  </h5><p>#{data.start_location}/p></li>
            <li><h5>Number of Clues:  </h5><p>#{data.loc.length}</p></li>
            <li><h5>Participants:  </h5>#{entry}</li>
          </ul>")
      else if currentTab.hasClass('huntClues')
        $('.huntDisplay').prepend("<h4>Clue #{data.current.progress} of #{data.loc.length}</h4><br>
          <p>My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker.</p><br>
          <form class='answer'>
            <input type='text' id='answer' name='answer' placeholder='Check your answer...' />
            <input type='submit' />
            </form>
          <h3 class='completed' data-info='#{data.title}'>Completed Clues</h3>")
      else if currentTab.hasClass('huntMap')
        $('.huntDisplay').prepend("<div class='map'>Map</div>")
      else
        $('.huntDisplay').prepend("#{leaders}")









