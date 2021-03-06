L.mapbox.accessToken = 'pk.eyJ1IjoiaW9leGNlcHRpb24iLCJhIjoiMHh6bEJYayJ9.HEXx3zsabVu0J7S12XPjzA';
var map = L.mapbox.map('map', 'ioexception.lhif9p6f');
map.locate({setView : true});
L.control.locate({setView : true}).addTo(map);
L.control.fullscreen().addTo(map);
var layers = document.getElementById('menu-ui');


function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}
var pointsAdded = 0;
var featureGroup = L.featureGroup()
var path_points = new L.MarkerClusterGroup();
addLayer(path_points, I18n.t("map.points"),1)
addLayer(featureGroup, I18n.t("map.lines"),2)
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
        		marker.bindPopup(I18n.t("loading"));
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
				'<b>'+I18n.t("map.lat")+'</b> '+loc.latitude+'<br>'+
				'<b>'+I18n.t("map.long")+'</b> '+loc.longitude+'<br>'+
				'<b>'+I18n.t("map.speed")+'</b> '+loc.speed+I18n.t("speed_val")+'.<br>'+
				'<b>'+I18n.t("map.distance")+'</b> '+loc.distance+ I18n.t("distance_val")+'.<br>'+
				'<b>'+I18n.t("map.duration")+'</b> '+moment.duration(loc.dur_time,"minutes").locale(I18n.locale).humanize()+'.'+
				'<p><b>'+I18n.t("map.address")+': </b> '+loc.address+'. </p>'
			);
    });
});


function addLayer(layer, name, zIndex) {
    layer
        .setZIndex(zIndex)
        .addTo(map);

    // Create a simple layer switcher that
    // toggles layers on and off.
    var link = document.createElement('a');
        link.href = '#';
        link.className = 'active';
        link.innerHTML = name;

    link.onclick = function(e) {
        e.preventDefault();
        e.stopPropagation();

        if (map.hasLayer(layer)) {
            map.removeLayer(layer);
            this.className = '';
        } else {
            map.addLayer(layer);
            this.className = 'active';
        }
    };

    layers.appendChild(link);
}