// // Plots map showing current location
// var map;
// var currentPos;
// function initialize() {
//   var mapOptions = {
//     zoom: 16,
//     mapTypeId: google.maps.MapTypeId.ROADMAP
//   };
//   map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

//   navigator.geolocation.getCurrentPosition(function(position){
//     currentPos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
//      map.setCenter(currentPos);
//   });


//   function markCurrentLocation () {
//     console.log(currentPos);
//     var marker = new google.maps.Marker({
//         position: currentPos,
//         map: map,
//         title: 'This is your current location'
//     });
//   };

//   function codeAddress() {
//     var geocoder = new google.maps.Geocoder();
//     var address = document.getElementById('address').value;
//     geocoder.geocode( { 'address': address}, function(results, status) {
//       if (status == google.maps.GeocoderStatus.OK) {
//         map.setCenter(results[0].geometry.location);
//         var marker = new google.maps.Marker({
//             map: map,
//             position: results[0].geometry.location
//         });
//         } else {
//           alert('Geocode was not successful for the following reason: ' + status);
//       }
//     });
//   }

//  google.maps.event.addDomListener(currentLocButton, 'click', markCurrentLocation);
//  google.maps.event.addDomListener(searchButton, 'click', codeAddress);
// }

// google.maps.event.addDomListener(window, 'load', initialize);
