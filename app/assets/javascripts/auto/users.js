var ready = function(){
    Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function(color) {
    return {
        radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
        stops: [
            [0, color],
            [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
        ]
    };
});

}


$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:change', ready);

$(function () {
  if(typeof colors == 'undefined'){
      colors=['red','green']//Highcharts.getOptions().colors;
    }
    // Radialize the colors
    Highcharts.getOptions().colors = Highcharts.map(gon.cars_tracks_colors, function (color) {
        return {
            radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
            stops: [
                [0, color],
                [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
            ]
        };
    });

    // Build the chart
    $('#tracks_for_cars_diagram').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'The percentage tracks for cars'
        },
        tooltip: {
            pointFormat: '<b>{point.percentage:.1f}%</b> {series.name}'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor)  || 'black'
                    },
                    connectorColor: 'silver'
                }
            }
        },
        series: [{
            type: 'pie',
            name: 'of total tracks',
            data: gon.cars_tracks_percent
        }]
    });
});


