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
      $('.huntList ul').prepend("<li data-role='#{h.role}'>
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
    if $(this).data('role') == 'hunter'
      $('.huntMasterView').addClass('display')
      $('.huntView').removeClass('display')
    else
      $('.huntView').addClass('display')
      $('.huntMasterView').removeClass('display')

  # When new hunt button is clicked it will display the huntmaster view
  $('.addHunt').click ->
    $('.indexView').addClass('display')
    $('.huntMasterView').removeClass('display')

  # When back button is pressed, the index page is displayed
  $('.goBack').click ->
    $('.huntMasterView').addClass('display')
    $('.indexView').removeClass('display')



    #**** Huntmaster View ****
    #display hunt info
  $('.huntMasterTabs').on 'click', '.huntMasterNav', ->
    # grab the current tab to use in the callback
    currentTab = $(this)
    console.log currentTab

    # clear the tab of previous data
    $('.huntMasterDisplay').empty()
      # if Hunt Details tab is clicked, show the Create Hunt form
    if currentTab.hasClass('huntMasterDetails')
      $('.huntMasterDisplay').prepend("<form>
        <h3>Create a hunt!</h3>
        Hunt Title: <input type='text' name='title'><br>
        Hunt Description: <input type='text' name='description'><br>
        Hunt Start Date: <input type='text' name='start_date'><br>
        Hunt Start Time: <input type='text' name='start_time'><br>
        <button class='add_participants'>Add Participants</button>
        <ul></ul>
        <input type='submit' value='Save Hunt'>
        </form>")
    else
      # if the clues tab is clicked, show the map
      $('.huntMasterDisplay').prepend("<div class='map'>Map</div>")

    # populating the ul with potential participants
  $('.huntMasterTabs').on 'click', '.add_participants', ->









  # Displaying the hunter view information
  $('.huntTabs').on 'click', '.huntNav', ->
    # Grab the current tab to use in the callback function
    currentTab = $(this)

    # Grab the id of the hunt for the ajax call
    id = $(this).parent().data('id')

    # Make the ajax call to get the hunt information
    call = $.ajax("/hunts/#{id}", {
        method: 'GET'
      })


    # Display the hunt information after the ajax call is successful
    call.done (data) ->
      # Clear out any information that the hunt display is showing, so the new info can be shown
      $('.huntDisplay').empty()
      console.log data
      # Displaying the correct information based on which tab is currently active
      if currentTab.hasClass('huntDetails')
        $('.huntDisplay').prepend("<ul class='details'>
            <li><h5>Hunt Title:  </h5><p>#{data.title}</p></li>
            <li><h5>Hunt Description:  </h5><p>#{data.description}</p></li>
            <li><h5>Hunt Prize:  </h5><p>#{data.prize}</p></li>
            <li><h5>Start on:  </h5><p>blah</p></li>
            <li><h5>Start Location:  </h5><p>blah</p></li>
            <li><h5>Number of Clues:  </h5><p>blah</p></li>
            <li><h5>Participants:  </h5><p>blah</p></li>
          </ul>")
      else if currentTab.hasClass('huntClues')
        $('.huntDisplay').prepend("<h4>Clue 5 of 10</h4><br>
          <p>My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker.</p><br>
          <h3 class='completed' data-info='#{data.title}'>Completed Clues</h3>")
      else if currentTab.hasClass('huntMap')
        $('.huntDisplay').prepend("<div class='map'>Map</div>")
      else
        $('.huntDisplay').prepend("<ul class='leaders'>
          <li><h5>Jennie</h5><p>5</p></li>
          <li><h5>Nico</h5><p>3</p></li>
          <li><h5>James</h5><p>3</p></li>
          <li><h5>Leon</h5><p>1</p></li>
          </ul>")

  $('.completed').click ->
    alert 'hi'







