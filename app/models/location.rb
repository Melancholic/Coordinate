class Location < ActiveRecord::Base
	self.inheritance_column = :state 
	scope :simples, -> { where(state: 'Location') } 
	scope :tracks, -> { where(state: 'TrackLocation') } 
	validates :speed, presence: false
	validates :time, presence: false 
	validates :distance, presence: false 
 	reverse_geocoded_by :latitude, :longitude
  	after_validation :geocode_run;

  	
private 
	def geocode_run
    	reverse_geocode
  	end
end
