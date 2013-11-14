// Define global variables
var map;
var currentPos;
var marker;
var JLmapOptions;
var JLMap;
var JLcenter;
var JLmapTypeId;
var windowContent;
var markerArray;
var infowindow;


//makeMap uses json data for hunt to plot locations and show clues in infowindows
function makeMap(thisHuntData, role, prog){
  windowContent = [];
  markerArray = [];
  var maxShowMarker;
  function setMaxShowMarker (){
    if (role==="hunter"){
      maxShowMarker = prog-1;
    }
    else maxShowMarker = thisHuntData.loc.length;
  };
  setMaxShowMarker();
  JLcenter = new google.maps.LatLng(thisHuntData.loc[0].lat, thisHuntData.loc[0].long);
  JLmapTypeId = google.maps.MapTypeId.ROADMAP
    JLmapOptions = {
      zoom: 12,
      mapTypeId: JLmapTypeId,
      center: JLcenter
    };
  JLMap = new google.maps.Map(document.getElementById('huntMap'), JLmapOptions);
    for (var i = 0; i < maxShowMarker; i++){

        var marker = new google.maps.Marker({
          position: new google.maps.LatLng(thisHuntData.loc[i].lat,thisHuntData.loc[i].long),
          map: JLMap,
        });
        markerArray[i]=marker;
        marker.myIndex = i;

        //fill in content window with hunt details for huntmaster
          var contentString ='<div> Clue number ' + thisHuntData.loc[i].clues[0].id + '</br> Clue: ' + thisHuntData.loc[i].clues[0].question + ' </br> Answer: ' + thisHuntData.loc[i].clues[0].answer + '</div>';

          windowContent[i] = contentString;

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
};

//function initialize plots map showing current location, and contains functions markCurrentLocation and codeAddress
function initialize() {
 navigator.geolocation.getCurrentPosition(function(position){
    currentPos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
  var mapOptions = {
    zoom: 16,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  alert(position.coords.latitude);
  map = new google.maps.Map(document.getElementById('map-foo'), mapOptions);
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
      // Enter lat and long into new clue marker form
      document.getElementById('location_lat').value=currentPos.ob;
      document.getElementById('location_long').value=currentPos.pb;
      google.maps.event.addDomListener(marker, 'dragend',markerMoved);
    });
  }
//update co-ordinates for new clue marker if marker moved (before saved to db)
  function markerMoved(){
    document.getElementById('location_lat').value=marker.position.ob;
    document.getElementById('location_long').value=marker.position.pb;
  };

}

// google.maps.event.addDomListener(window, 'load', initialize);

