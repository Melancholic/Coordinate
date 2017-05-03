class TrackLocation < Location
  self.table_name = 'locations'
  validates :speed, presence: true
  validates :time, presence: true
  validates :track, presence: true
  belongs_to :track
  default_scope -> {order(time: :asc, id: :asc)}
  scope :by_track, -> (track) {where(track: track)}
  scope :by_car, -> (car) {joins(:track).where('tracks.car_id = ?', car.id)}

  before_save :calculate_distance


  after_save do
    self.track.update_attributes(start_time: self.time) if self.track.start_time.nil? ||
        (self.time < self.track.start_time)

    self.track.update_attributes(stop_time: self.time) if self.track.stop_time.nil? ||
        (self.time > self.track.stop_time)

    Thread.new do
      locs = self.track.track_locations.where('time > ?', self.time)
      locs.each(&:calculate_distance!)
      ActiveRecord::Base.connection.close
    end
  end

  def calculate_distance!
    pred = self.track.track_locations.where('time < ?', self.time).last
    if pred && pred.distance.present?
      self.update_attributes!(distance: pred.distance + Geocoder::Calculations.distance_between(self, pred))
    else
      self.update_attributes!(distance: 0)
    end
  end

  private
  def calculate_distance
    pred = self.track.track_locations.where('time < ?', self.time).last
    if pred && pred.distance.present?
      self.distance = pred.distance || 0
      self.distance += Geocoder::Calculations.distance_between(self, pred)
    else
      self.distance=0;
    end
  end

end
