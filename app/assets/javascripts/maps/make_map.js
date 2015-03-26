L.mapbox.accessToken = 'pk.eyJ1IjoiaW9leGNlcHRpb24iLCJhIjoiMHh6bEJYayJ9.HEXx3zsabVu0J7S12XPjzA';
var map = L.mapbox.map('map', 'ioexception.lhif9p6f').setView([0, 0], 18);
$("#findme_but").click(function() {
	map.setView(gon.umark, 10);
});

function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}
var pointsAdded = 0;
add();
function add() {
	if (gon.locs_){
		gon.locs.forEach(function(track) {
			var counter=0;
			var polyline = L.polyline([],{color: getRandomColor()}).addTo(map);
			track.forEach(function(loc) {
				polyline.addLatLng(
					L.latLng(loc.latitude,
						loc.longitude));
			});
		});
	}

	var marker = L.marker(gon.umark , {
		icon: L.mapbox.marker.icon({
			'marker-color': '#f86767'
		})})
	marker.addTo(map);
	map.setView([0, pointsAdded], 10);
}