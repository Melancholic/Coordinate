function time(arg){
	if (arg==null){
		return 'Now'
	}
	var x=moment(arg);
	return x.format('hh:mm');
}
function convert_datetime(arg){
	if (arg==null){
		return 'Now'
	}
	var x=moment(arg);
	return x.format('DD.MM.YYYY : hh:mm');
}
function convert_date(arg){
	if (arg==null){
		return 'Today'
	}
	var x=moment(arg);
	return x.format('DD.MM.YYYY');
}