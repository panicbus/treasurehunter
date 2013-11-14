// Define global variables
var map;
var currentPos;
var marker;
var JLmapOptions;
var JLMap;
var JLcenter;
var JLmapTypeId;
var latitude, longitude, accuracy;
var windowContent;
var markerArray;
var infowindow;

//makeMap uses json data for hunt to plot locations and show clue in infowindow
function makeMap(thisHuntData){
  windowContent = [];
  markerArray = [];
  JLcenter = new google.maps.LatLng(thisHuntData.loc[0].lat,thisHuntData.loc[0].long);
  JLmapTypeId = google.maps.MapTypeId.ROADMAP
    JLmapOptions = {
      zoom: 12,
      mapTypeId: JLmapTypeId,
      center: JLcenter
    };
  JLMap = new google.maps.Map(document.getElementById('huntMap'), JLmapOptions);
    for (var i = 0; i < thisHuntData.loc.length; i++){
        var marker = new google.maps.Marker({
          position: new google.maps.LatLng(thisHuntData.loc[i].lat,thisHuntData.loc[i].long),
          map: JLMap,
        });
        markerArray[i]=marker;
        marker.myIndex = i;
          windowContent[i] = thisHuntData.loc[i].clues[0].question;
            google.maps.event.addListener(marker, 'click', function() {
              if(infowindow) {
                  infowindow.close();
              }
            infowindow = new google.maps.InfoWindow({
              content: windowContent[this.myIndex]
              });
            infowindow.open(JLMap,this);
          });
    }
console.log(windowContent);
console.log(i);
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
            title: 'This is your current location',
        });
      google.maps.event.addDomListener(marker, 'dragend', markerMoved);
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
      document.getElementById('location_lat').value=currentPos.ob;
      document.getElementById('location_long').value=currentPos.pb;
      google.maps.event.addDomListener(marker, 'dragend',markerMoved);
    });
  }

  function markerMoved(){
    document.getElementById('location_lat').value=marker.position.ob;
    document.getElementById('location_long').value=marker.position.pb;
  };

}
  // sets the device's geolocation and check on regular intervals
  function setGeolocation() {
    // watchPosition will regularly check geolocation
    var geolocation = window.navigator.geolocation.watchPosition(
        function ( position ) {
            latitude = position.coords.latitude;  // and stores lat/long to print
            longitude = position.coords.longitude;
            // accuracy = position.coords.accuracy;
        },
        function () {
            maximumAge: 250, // determines how long to keep location cache in miliseconds
            enableHighAccuracy: true
        }
    );

    window.setTimeout( function () {
            window.navigator.geolocation.clearWatch( geolocation )
        },
        (1000 * 60 * 20) // determines when to stop checking for location, in this case after 20 minute
    );
  };

  // setGeolocation();

  // window.setInterval( function () {
  //         test = setGeolocation();
  //         console.log(test);
  //     },
  //     15000 //check every 15 seconds
  // );

google.maps.event.addDomListener(window, 'load', initialize);
