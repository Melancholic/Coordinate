##
#Модель, содержащая данные о сообщениях,
#отправленных пользователсями
#с контактной формы.
##
class UsersMail < ActiveRecord::Base
    # Константное регулярное выражение,
    # определяющее валидный e-mail 
	VALID_EMAIL_REGEX =  /\A[\w+\-.0-9]+@([a-z\d\-]+(\.[a-z\d]+)*\.[a-z]+)+\z/i
    # Константное регулярное выражение,
    # определяющее валидные имя и фамилию
	VALID_NAME_REGEX = /\A[a-zA-Zа-яА-Я]+\z/i
  apply_simple_captcha
  validates(:email, presence: true, length:{maximum:50,minimum:3},
      format: {with: VALID_EMAIL_REGEX});
  validates(:first_name, length:{maximum:20}, presence: true, format: {with: VALID_NAME_REGEX},allow_blank: false );
  validates(:last_name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  validates(:subject, length:{maximum:50, minimum:5}, presence: true, allow_blank: false );
  validates(:message, length:{maximum:1000, minimum:25}, presence: true ,allow_blank: false );
  default_scope -> {order(opened: :desc, created_at: :desc)}
  scope :opened, -> { where(opened: true)}
  scope :closed, -> { where(opened: false)}
  before_save{
    self.email=email.downcase;
  } 

  after_create :send_to_admins;

  # pagination
  self.per_page = 15;
private
  # Метод, создающий рассылку
  # администраторам.
  def send_to_admins
    User.admins.each do |x|
      SystemMailer.contact_us_mail(self,x).deliver_now;
    end
  end

  belongs_to :user;

end
