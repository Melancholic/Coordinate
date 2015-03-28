L.mapbox.accessToken = 'pk.eyJ1IjoiaW9leGNlcHRpb24iLCJhIjoiMHh6bEJYayJ9.HEXx3zsabVu0J7S12XPjzA';
var map = L.mapbox.map('map', 'ioexception.lhif9p6f').setView(gon.umark, 10);
var marker = L.marker(gon.umark , {
	icon: L.mapbox.marker.icon({
		'marker-color': '#f86767'
})})
marker.addTo(map);

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
var featureGroup = L.featureGroup().addTo(map);

function add_locs_to_map(locs) {
		featureGroup.clearLayers();
		locs.forEach(function(track) {
			var counter=0;
			var polyline = L.polyline([],{color: getRandomColor()}).addTo(featureGroup);
			track.forEach(function(loc) {
				polyline.addLatLng(
					L.latLng(loc.latitude,
						loc.longitude));
			});
		});
	


}