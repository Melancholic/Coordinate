VALID_EMAIL_REGEX =  /\A[\w+\-.0-9]+@([a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+)+\z/i
VALID_login_REGEX = /\A[a-z \d \- \_]*[a-z \- \_]+[a-z \d \- \_]*\z/i
TIME_LIM_PASSRST_KEY =30;
class User < ActiveRecord::Base
  has_one :verification_user, dependent: :destroy;
  has_one :reset_password;
  #Порядок
  default_scope -> {order('login ASC')}

  validates(:login, presence: true, length:{maximum:15,minimum:3},format: {with: VALID_login_REGEX});
  validates(:email, presence: true, length:{maximum:50,minimum:3},
      format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false});
  
  before_save{
    self.email=email.downcase;
  }
  after_create{
    self.verificate!
    #self.verification_user=VerificationUser.create(user_id: self.id, verificated:false);
  }

  before_create :create_remember_token;
  
  has_secure_password();
  validates :password, length: { minimum: 6}, allow_nil: true
  # validates :password, :presence => true,
  #                     :confirmation => true,
  #                     :length => {:within => 6..40},
  #                     :on => :create
  # validates :password, :confirmation => true,
  #                     :length => {:within => 6..40},
  #                     :allow_blank => true,
  #                     :on => :update
  
 
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

private
  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token());
  end
end
