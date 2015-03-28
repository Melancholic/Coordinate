function convert_datetime(arg){
	if (arg==null){
		return 'NOW'
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