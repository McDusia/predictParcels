var latitude1 = 39.46;
var longitude1 = -0.36;
var latitude2 = 40.40;
var longitude2 = -3.68;

var distance = google.maps.geometry.spherical.computeDistanceBetween(new google.maps.LatLng(latitude1, longitude1), new google.maps.LatLng(latitude2, longitude2)); 

console.out(distance)