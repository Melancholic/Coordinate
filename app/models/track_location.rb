class TrackLocation < Location
   self.table_name = 'locations'
   	validates :speed, presence: true
	validates :time, presence: true 
	belongs_to :track
end
