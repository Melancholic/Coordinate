# Регулярное выражение, задающее корректный e-mail ползователя.
VALID_EMAIL_REGEX =  /\A[\w+\-.0-9]+@([a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+)+\z/i
# Регулярное выражение, задающее корректный логин пользователя.
VALID_login_REGEX = /\A[a-z \d \- \_]*[a-z \- \_]+[a-z \d \- \_]*\z/i
# Максимальное время жизни ссылки на сброс пароля (мин.).
TIME_LIM_PASSRST_KEY =30;
class User < ActiveRecord::Base
    extend ActiveModel::Callbacks
  apply_simple_captcha
  has_one :verification_user, dependent: :destroy;
  has_one :reset_password;
  has_one :profile, dependent: :destroy;
  has_many :cars, dependent: :destroy, inverse_of: :user;
  accepts_nested_attributes_for :profile, update_only:true, allow_destroy: true
  #Порядок
  default_scope -> {order('login ASC')}
  scope :admins, -> { where(admin: true)}
  scope :lasted, -> {unscoped.order(created_at: :desc)}
  scope :by_time_asc, -> {unscoped.order(created_at: :asc)}
  scope :with_cars, ->{joins(:cars).uniq}
#  geocoded_by :ip_address

  validates(:login, presence: true, uniqueness: {case_sensitive: false}, length:{maximum:15,minimum:3},format: {with: VALID_login_REGEX});
  validates(:email, presence: true, length:{maximum:50,minimum:3},
      format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false});
  validates :locale, presence: true, :locale_format => true
  
  #after_initialize{
  #  self.create_profile
  #}
  before_save{
    self.email=email.downcase;
    self.auth_hash= Digest::SHA256.hexdigest(self.email+self.password) if self.password;
  } 

  after_create{

    self.verificate!
  }

 # after_validation :geocode 

  before_create{
    #self.build_profile
    create_remember_token
  }
  
  has_secure_password();
  validates :password, length: { minimum: 6}, allow_nil: true
  
  # pagination
  self.per_page = 10;
  
  def self.get_regex
     return /[@][a-zA-Zа-яА-Я0-9\_]+/;
  end
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64;
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  

  def verificated?()
    self.verification_user.verificated
  end

  def verificate!(flag=false)
  unless (self.verification_user.nil?)
    self.verification_user.update_attributes(verificated:flag)
  else
    self.verification_user=VerificationUser.create(user_id: self.id, verificated:flag);
  end
    self.verificated?
  end

  def verification_key()
    self.verification_user.verification_key
  end

  def reset_password_key()
    if(self.reset_password)
      self.reset_password.password_key
    else
      nil
    end
  end
  
  def make_reset_password(args)
    if(self.reset_password)
      self.reset_password.delete;
      self.create_reset_password(args);
    else
      self.create_reset_password(args);
    end
  end

  def full_region
    return "" unless (self.profile); 
    [self.profile.country, self.profile.region, self.profile.city].delete_if{|x| x.nil? || x.empty?}.join(', ')
  end

  def full_name 
    ([self.name,self.middle_name, self.second_name].compact.delete_if{|x| x.empty?}).join(' ')
  end
  
  def short_name 
    ([self.second_name, self.name.initial, self.middle_name.initial].compact.delete_if{|x| x.empty?}).join(' ')
  end
  
  def admin_display_name
    "#{self.login} [#{self.short_name}]"
  end

  def name
    (self.profile)? self.profile.name : nil
  end

  def name=(new_name)
    self.profile.update_attributes(name: new_name)
    self.name
  end

  def second_name
    (self.profile)? self.profile.second_name : nil
  end
  def second_name=(new_second_name)
    self.profile.update_attributes(second_name: new_second_name)
    self.second_name
  end
  
  def middle_name
    (self.profile)? self.profile.middle_name : nil
  end

  def middle_name=(new_middle_name)
    self.profile.update_attributes(middle_name: new_middle_name)
    self.middle_name
  end

  def avatar
    if self.profile && self.profile.image
      self.profile.image.img  
    else
      nil
    end
  end
  
  def avatar=(arg)
    if(self.profile.nil?)
      return
    end
    unless self.profile.image
      self.profile.create_image(img:arg)
    else
      self.profile.image.update_attributes(img:arg)
    end
    self.profile.image
  end

  def avatar?
    if self.profile && self.profile.image
      !self.profile.image.img.nil?
    else
      nil
    end
  end

  def create_car(args={})
    if args[:user_id] || args[:user_id]!=self.id
      args[:user_id]=self.id
    end
    self.cars<< Car.new(args)
    self.save
  end

  def local_time(time)
    return "now" if time.nil?
    zone=ActiveSupport::TimeZone.new(self.time_zone)
    time.in_time_zone(zone).strftime("%d.%m.%y %H:%M")
  end

  def all_tracks()
    Track.where(car: self.cars)
  end

  def group_tracks_by_day(arg)
    arg||=:all;
    if(arg == :all)
      tracks_sql=self.all_tracks
      name=I18n.t('charts.all_cars')
      color="#32CD32"
    elsif(arg.instance_of?(Car) && self.cars.include?(arg))
      tracks_sql=arg.tracks
      name=arg.title
      color=arg.color_html
    else
      return nil
    end
      #x=tracks_sql.where("start_time < ? AND start_time > ?",Time.now.beginning_of_day+1.day, Time.now.beginning_of_day-1.month).
      #map{|x| [x.start_time.beginning_of_day , x.distance.round(3)] if  x.distance >0}.compact.
      #group_by(&:first).map { |k,v| [k, v.map(&:last).inject(:+)] }
      
      x=Track.unscoped.from(
        "(SELECT tracks.start_time, MAX(distance) AS distance FROM 
          locations INNER JOIN tracks ON locations.track_id = tracks.id
          WHERE track_id IN (#{tracks_sql.select(:id).to_sql}) 
          GROUP BY track_id, tracks.start_time ) AS subquery").group_by_day(:start_time, last: 30).sum(:distance)

      result={name:name, data:x.sort{|a,b| a[0] <=> b[0] }, color:color } unless x.empty?
  end

private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token());
  end
end
