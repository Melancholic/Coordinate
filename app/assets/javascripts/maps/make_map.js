L.mapbox.accessToken = 'pk.eyJ1IjoiaW9leGNlcHRpb24iLCJhIjoiMHh6bEJYayJ9.HEXx3zsabVu0J7S12XPjzA';
var map = L.mapbox.map('map', 'ioexception.lhif9p6f');
map.locate({setView : true});
L.control.locate({setView : true}).addTo(map);
L.control.fullscreen().addTo(map);
/*$("#findme_but").click(function() {
	map.locate({setView : true});
});*/

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
var path_points = new L.MarkerClusterGroup().addTo(map);

function add_locs_to_map(locs) {
		featureGroup.clearLayers();
		path_points.clearLayers();
		locs.forEach(function(track) {
			var counter=0;
			var rand_color= getRandomColor();
			var polyline = L.polyline([],{color:rand_color}).addTo(featureGroup);
			track.forEach(function(loc) {
				polyline.addLatLng(L.latLng(loc.latitude,loc.longitude));
				var marker = L.marker(new L.LatLng(loc.latitude,loc.longitude), {
            		icon: L.mapbox.marker.icon({'marker-symbol': 'marker', 'marker-color': rand_color}),
            		title: convert_datetime(loc.time)
        		});
        		marker.bindPopup("Loading...");
        		marker['loc_id']=loc.id;
        		path_points.addLayer(marker);

			});
			map.fitBounds(polyline.getBounds());
	
		});
}

map.on('popupopen',function(e) {
	var params={id:e.popup._source.loc_id};
	$.getJSON( maps_location_path, params,  function( data ) {
			var loc=data.location;
			e.popup.setContent('<b> '+convert_datetime(loc.time)+'</b><hr>'+
				'<b>Latitude</b> '+loc.latitude+'<br>'+
				'<b>Longitude</b> '+loc.longitude+'<br>'+
				'<b>Speed</b> '+loc.speed+' km/h.<br>'+
				'<b>Distance:</b> '+loc.distance+' km.<br>'+
				'<b>Duration: </b> '+moment.duration(loc.dur_time,"minutes").humanize()+'.'+
				'<p><b>Address: </b> '+loc.address+'. </p>'
			);
    });
});


