// Define global variables
var map;
var currentPos;
var marker;
var JLmapOptions;
var JLMap;
var JLcenter;
var JLmapTypeId;

function makeMap(thisHuntData){
  JLcenter = new google.maps.LatLng(thisHuntData.loc[0].lat,thisHuntData.loc[0].long);
  JLmapTypeId = google.maps.MapTypeId.ROADMAP
    JLmapOptions = {
      zoom: 12,
      mapTypeId: JLmapTypeId,
      center: JLcenter
    };

  JLMap = new google.maps.Map(document.getElementById('huntMap'), JLmapOptions);
    for (var i = 0; i < thisHuntData.loc.length; i++){
        var huntLocation = new google.maps.Marker({
          position: new google.maps.LatLng(thisHuntData.loc[i].lat,thisHuntData.loc[i].long),
          map: JLMap
        });
    }
};

function makeMap(thisHuntData){
  JLcenter = new google.maps.LatLng(thisHuntData.loc[0].lat,thisHuntData.loc[0].long);
  JLmapTypeId = google.maps.MapTypeId.ROADMAP
    JLmapOptions = {
      zoom: 12,
      mapTypeId: JLmapTypeId,
      center: JLcenter
    };

  JLMap = new google.maps.Map(document.getElementById('huntMap'), JLmapOptions);
    for (var i = 0; i < thisHuntData.loc.length; i++){
        var huntLocation = new google.maps.Marker({
          position: new google.maps.LatLng(thisHuntData.loc[i].lat,thisHuntData.loc[i].long),
          map: JLMap
        });
    }
};

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

 google.maps.event.addDomListener(currentLocButton, 'click', markCurrentLocation);
 google.maps.event.addDomListener(searchButton, 'click', codeAddress);

//adds marker to current location
  function markCurrentLocation () {
    document.getElementById('address').value='';
    navigator.geolocation.getCurrentPosition(function(position){
      currentPos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      map.setCenter(currentPos);
      document.getElementById('location_lat').value=currentPos.ob;
      document.getElementById('location_long').value=currentPos.pb;
        marker = new google.maps.Marker({
            position: currentPos,
            map: map,
            draggable: true,
            title: 'This is your current location'
        });
      google.maps.event.addDomListener(marker, 'dragend', markerMoved(marker));
    });

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
      console.log('from codeAddress is currentPos');
      console.log(currentPos);
      document.getElementById('location_lat').value=currentPos.ob;
      document.getElementById('location_long').value=currentPos.pb;
      google.maps.event.addDomListener(marker, 'dragend',markerMoved(marker));
    });
  }

  function markerMoved(movedMarker){
    movedMarker.title = movedMarker.position;
    // Enter lat and long into form
    console.log('from markerMoved is position.ob');
    console.log(movedMarker.position.ob);
    document.getElementById('location_lat').value=movedMarker.position.ob;
    document.getElementById('location_long').value=movedMarker.position.pb;
  }

}

google.maps.event.addDomListener(window, 'load', initialize);
