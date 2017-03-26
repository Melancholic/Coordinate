class Location < ActiveRecord::Base
	validates :speed, presence: false
	validates :time, presence: false 
	validates :distance, presence: false 
 	reverse_geocoded_by :latitude, :longitude
  	after_validation :geocode_run;

  	
    private 
    def geocode_run
        begin
            reverse_geocode
        rescue Errno::ENETUNREACH => x
            logger.error("Geocoder is down: #{x.to_s}")
        end
    end
end
