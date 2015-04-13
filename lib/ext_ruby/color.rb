class Color
	COLORS=%w(
    	FFFFFF
	    000000
	    FF0000
	    FFFF00
	    0000FF
	    000080
	    008000
	    FF00FF);

	def self.all
		COLORS;
	end

	def self.all_html
		COLORS.map{|x| '#'+x};
	end
	def self.select_array
		COLORS.map{|x| ['#'+x, x, {data: {color: '#'+x}}]}
	end

end