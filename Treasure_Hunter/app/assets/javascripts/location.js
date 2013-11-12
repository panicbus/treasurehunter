
//Define global variables
var map;
var currentPos;
var latitude;
var longitude;
var marker;

//function initialize plots map showing current location, and contains functions markCurrentLocation and codeAddress
function initialize() {
  var mapOptions = {
    zoom: 16,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  navigator.geolocation.getCurrentPosition(function(position){
    currentPos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
     map.setCenter(currentPos);

  });

//adds marker to current location
  function markCurrentLocation () {
    // var coordinates = document.getElementById('coordinates');
    marker = new google.maps.Marker({
        position: currentPos,
        map: map,
        draggable: true,
        title: 'This is your current location'
    });

    console.log('current location is ' + currentPos);

    // Enter lat and long into form
    document.getElementById('location_lat').value=currentPos.nb;
    document.getElementById('location_long').value=currentPos.ob;
    latitude = currentPos.nb;
    longitude = currentPos.ob;

    google.maps.event.addDomListener(marker, 'dragend', function() { markerMoved(marker); } );
  };

//plots map and marker showing user-entered address
  function codeAddress() {
    var coordinates = document.getElementById('coordinates');
    var geocoder = new google.maps.Geocoder();
    var address = document.getElementById('address').value;
    geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        currentPos = results[0].geometry.location;
        map.setCenter(currentPos);
        marker = new google.maps.Marker({
            map: map,
            position: currentPos,
            draggable: true
        });
        } else {
          alert('Geocode was not successful for the following reason: ' + status);
      }
      // Enter lat and long into form
      document.getElementById('location_lat').value=currentPos.nb;
      document.getElementById('location_long').value=currentPos.ob;
      latitude = currentPos.nb;
      console.log(latitude);
      google.maps.event.addDomListener(marker, 'dragend', function() { markerMoved(marker); } );
    });
  }
//
  function markerMoved(movedMarker){
    movedMarker.title = movedMarker.position;
    console.log('new marker position is ' + movedMarker.position);
    latitude = currentPos.nb;
    // Enter lat and long into form
    document.getElementById('location_lat').value=movedMarker.position.nb;
    document.getElementById('location_long').value=movedMarker.position.ob;
  }
  console.log(latitude);
 google.maps.event.addDomListener(currentLocButton, 'click', markCurrentLocation);
 google.maps.event.addDomListener(searchButton, 'click', codeAddress);

}

google.maps.event.addDomListener(window, 'load', initialize);
