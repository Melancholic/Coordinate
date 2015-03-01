class ResetPassword < ActiveRecord::Base
  before_create{
    self.password_key=SecureRandom.urlsafe_base64;
  }

  def get_user()
    User.find(self.user_id);
  end

  def self.get_user(key)
    key = key[:password_key] if  key.instance_of? ResetPassword;
    rp=ResetPassword.find_by(password_key: key.to_s);
    User.find(rp.user_id) if(rp);
  end
end
