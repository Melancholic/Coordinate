module UsersHelper
  
  def avatar_for(user,options={size: 100})
    options[:alt]||=user.login
    if user.avatar.nil?
      return gravatar_for(user, options);
    else
      image_tag(user.avatar.url, options)
    end
  end

private
  
  def gravatar_for(user,options={size: 100})
    grav_id=Digest::MD5::hexdigest(user.email.downcase);
    grav_url="https://secure.gravatar.com/avatar/#{grav_id}?s=#{options[:size]}";
    image_tag(grav_url, options);
  end

  def size_value(val)
    h=w=val
    "#{h}x#{w}"
  end
end
