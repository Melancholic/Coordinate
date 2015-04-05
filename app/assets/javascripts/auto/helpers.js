function time(arg){
	if (arg==null){
		return 'Now'
	}
	var x=moment(arg);
	return x.format('HH:mm');
}
function convert_datetime(arg){
	if (arg==null){
		return 'Now'
	}
	var x=moment(arg);
	return x.format('DD.MM.YYYY : HH:mm');
}
function convert_date(arg){
	if (arg==null){
		return 'Today'
	}
	var x=moment(arg);
	return x.format('DD.MM.YYYY');
}