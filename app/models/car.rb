class Car < ActiveRecord::Base
	DescriptionLength=180;
	has_one :api_token, dependent: :destroy;
	belongs_to :user, inverse_of: :cars;
	has_many :tracks, dependent: :destroy;
	belongs_to :image, dependent: :destroy;
	accepts_nested_attributes_for :image, update_only: true, :reject_if => proc { |attributes| attributes['img'].blank? }, :allow_destroy => true
	validates(:title, presence: true, length:{maximum:15,minimum:3});
	validates(:title, uniqueness: {scope: :user_id,
    message: :title_uniq_valid });
	validates :color, :color_format => true
	validates :priority, inclusion:{in: 0..10, message: :priority_valid }
	validates :description, length:{maximum: DescriptionLength ,minimum:3}
	default_scope -> { order(:priority => :desc, :title =>:asc) }
	scope :lasted, -> {unscoped.order(created_at: :desc)}
	scope :with_tracks, -> {joins(:tracks).uniq}
	scope :by_user, ->(usr) {where(user:usr)};
	self.per_page=5;

	before_create do 
		self.color.upcase!
		self.tracker_uuid=SecureRandom.hex(4);
		self.build_api_token()
	end

	def create_track(args)
		self.tracks.create!(args)
	end

	def img
		self.image.img;
	end

	def color_html
		"##{self.color}"
	end

	#Метод, предоставляющий информацию о автомобиле
	#Результат - хеш
	#Используется в в профиле пользователя, при наведении
	#на строку с автомобилем.
	def info
		result={};
		result[:speed_avg]="#{TrackLocation.where(track_id: self.track_ids).average('speed').to_f.round} #{I18n.t('speed_val')}";
		result[:speed_max]="#{TrackLocation.where(track_id: self.track_ids).maximum('speed').to_f.round} #{I18n.t('speed_val')}";
		result[:total_tracks_length]="#{self.total_tracks_length.round(3)} #{I18n.t('distance_val')}";
		result[:total_tracks_duration]="#{(self.total_tracks_duration/60/60).round()} #{I18n.t('hours_val')}";
		result[:tracks_count]="#{self.tracks.count}";
		result[:max_track_length]="#{self.max_track_length.round(3)} #{I18n.t('distance_val')}";
		result[:min_track_duration]="#{(self.min_track_duration/3600).round()} #{I18n.t('hours_val')}"
		result[:max_track_duration]="#{(self.max_track_duration/3600).round()} #{I18n.t('hours_val')}"
		return result
	end

	def max_track_length
		sql= Location.select("MAX(distance) as distance")
				.joins("INNER JOIN tracks ON tracks.id=locations.track_id")
				.where("tracks.car_id = ?", self.id).group(:track_id).to_sql
		res=Car.from("(#{sql}) l").maximum("l.distance")
		res||=0;
	end

	def total_tracks_length
		sql= Location.select("MAX(distance) as distance")
				.joins("INNER JOIN tracks ON tracks.id=locations.track_id")
				.where("tracks.car_id = ?", self.id).group(:track_id).to_sql
		res=Car.from("(#{sql}) l").sum("l.distance")
		res||=0;
	end

	#returned in seconds
	def total_tracks_duration
		sql= Location.select(" EXTRACT(EPOCH FROM MAX(time) - MIN(time) ) as duration")
				.joins("INNER JOIN tracks ON tracks.id=locations.track_id")
				.where("tracks.car_id = ?", self.id).group(:track_id).to_sql
		res=Car.from("(#{sql}) l").sum("l.duration")
		res||=0;
	end

	def min_track_duration
		sql= Location.select(" EXTRACT(EPOCH FROM MAX(time) - MIN(time) ) as duration")
				.joins("INNER JOIN tracks ON tracks.id=locations.track_id")
				.where("tracks.car_id = ?", self.id).group(:track_id).to_sql
		res=Car.from("(#{sql}) l").minimum("l.duration") 
		res||=0;
		
	end

	def max_track_duration
		sql= Location.select(" EXTRACT(EPOCH FROM MAX(time) - MIN(time) ) as duration")
				.joins("INNER JOIN tracks ON tracks.id=locations.track_id")
				.where("tracks.car_id = ?", self.id).group(:track_id).to_sql
		res=Car.from("(#{sql}) l").maximum("l.duration") 
		res||=0;
	end
end
