class Location < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode_run;
  
  private 
  def geocode_run
    geocode
  end
end
