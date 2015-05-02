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

function percent_tracks_for_cars_init(data) {
    Highcharts.getOptions().colors = Highcharts.map(data.colors, function (color) {
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
            data: data.data
        }]
    });
}


function percent_distance_for_cars_init(data) {
    Highcharts.getOptions().colors = Highcharts.map(data.colors, function (color) {
        return {
            radialGradient: { cx: 0.5, cy: 0.3, r: 0.7 },
            stops: [
                [0, color],
                [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
            ]
        };
    });

    // Build the chart
    $('#distance_for_cars_diagram').highcharts({
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false
        },
        title: {
            text: 'The percentage distance for cars'
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
            name: 'of total distance',
            data: data.data
        }]
    });
}




function length_tracks_of_time(data) {
    $('#length_tracks_of_time_diagram').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: 'Distance for days'
        },
        subtitle: {
            text: 'The daily distance of your tracks'
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            },
            title: {
                text: 'Date'
            }
        },
        yAxis: {
            title: {
                text: 'Track distance (km)'
            },
            min: 0
        },
        tooltip: {
            headerFormat: '<b>{series.name}</b><br>',
            pointFormat: '{point.x:%e. %b}: {point.y:.2f} km'
        },

        plotOptions: {
            spline: {
                marker: {
                    enabled: true
                }
            }
        },

        series: data
    });
}


function avg_speed_chart_init(data) {
    $('#speed_avg_for_all_car').highcharts({

        chart: {
            type: 'gauge',
            alignTicks: false,
            plotBackgroundColor: null,
            plotBackgroundImage: null,
            plotBorderWidth: 0,
            plotShadow: false
        },

        title: {
            text: 'Speed Average'
        },

        pane: {
            startAngle: -150,
            endAngle: 150
        },

        yAxis: [{
            min: 0,
            max: 200,
            lineColor: '#339',
            tickColor: '#339',
            minorTickColor: '#339',
            offset: -25,
            lineWidth: 2,
            labels: {
                distance: -20,
                rotation: 'auto'
            },
            tickLength: 5,
            minorTickLength: 5,
            endOnTick: false
        }, {
            min: 0,
            max: 124,
            tickPosition: 'outside',
            lineColor: '#933',
            lineWidth: 2,
            minorTickPosition: 'outside',
            tickColor: '#933',
            minorTickColor: '#933',
            tickLength: 5,
            minorTickLength: 5,
            labels: {
                distance: 12,
                rotation: 'auto'
            },
            offset: -20,
            endOnTick: false
        }],

        series: [{
            name: 'Speed',
            data: [data],
            dataLabels: {
                formatter: function () {
                    var kmh = data
                        mph = Math.round(kmh * 0.621);
                    return '<span style="color:#339">' + kmh + ' km/h</span><br/>' +
                        '<span style="color:#933">' + mph + ' mph</span>';
                },
                backgroundColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, '#DDD'],
                        [1, '#FFF']
                    ]
                }
            },
            tooltip: {
                valueSuffix: ' km/h'
            }
        }]

    })
}

function max_speed_chart_init(data) {
    $('#speed_max_for_all_car').highcharts({

        chart: {
            type: 'gauge',
            alignTicks: false,
            plotBackgroundColor: null,
            plotBackgroundImage: null,
            plotBorderWidth: 0,
            plotShadow: false
        },

        title: {
            text: 'Max Speed'
        },

        pane: {
            startAngle: -150,
            endAngle: 150
        },

        yAxis: [{
            min: 0,
            max: 200,
            lineColor: '#339',
            tickColor: '#339',
            minorTickColor: '#339',
            offset: -25,
            lineWidth: 2,
            labels: {
                distance: -20,
                rotation: 'auto'
            },
            tickLength: 5,
            minorTickLength: 5,
            endOnTick: false
        }, {
            min: 0,
            max: 124,
            tickPosition: 'outside',
            lineColor: '#933',
            lineWidth: 2,
            minorTickPosition: 'outside',
            tickColor: '#933',
            minorTickColor: '#933',
            tickLength: 5,
            minorTickLength: 5,
            labels: {
                distance: 12,
                rotation: 'auto'
            },
            offset: -20,
            endOnTick: false
        }],

        series: [{
            name: 'Speed',
            data: [data],
            dataLabels: {
                formatter: function () {
                    var kmh = data
                        mph = Math.round(kmh * 0.621);
                    return '<span style="color:#339">' + kmh + ' km/h</span><br/>' +
                        '<span style="color:#933">' + mph + ' mph</span>';
                },
                backgroundColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, '#DDD'],
                        [1, '#FFF']
                    ]
                }
            },
            tooltip: {
                valueSuffix: ' km/h'
            }
        }]

    })
}
