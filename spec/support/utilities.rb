include ApplicationHelper
#Capybara
## USE: find(:linkhref, <path>).click 
module Selectors
  Capybara.add_selector(:linkhref) do
    xpath {|href| ".//a[@href='#{href}']"}
  end
end

#Capybara end

def verificate (user, args={})
  if args[:no_capybara]
    puts  user.verification_user.verification_key;
    user.verification_user.update_attribute(:verification_key,"");
    user.verification_user.update_attribute(:verificated,true);
  else
      visit verification_user_path user;
       fill_in "key", with: user.verification_user.verification_key;
       click_button "Send key"
  end
end


def sign_in (user, args={})
  if args[:no_capybara]
    remember_token=User.new_remember_token();
    cookies[:remember_token]=remember_token;
    user.update_attribute(:remember_token,User.encrypt(remember_token));
  else
    visit root_path;
    click_link 'Authorization'
    click_link 'Log in'
    within("#signin_tab") do 
      fill_in "Email", with: user.email;
      fill_in "Password", with: user.password;
      click_button "Log in"
    end
  end
end

def sign_out (user, args={})
  if args[:no_capybara]
    delete(sign_out)
  else
      visit user_path(user);
      click_link("Sign Out");
  end
end

def setValidUsersData(user)
  user.login="Example user";
  user.email="example#{Random.rand(1000)}@mail.com";
  user.password="123456";
  user.password_confirmation=user.password;
    fill_in "Login", with: user.login;
    fill_in "Email", with: user.email;
    fill_in "Password", with: user.password;
    fill_in "Confirmation", with: user.password_confirmation;
  return user;
end
def setInvalidUsersData(user)
  user.login="uncorrect=Name";
  user.email="uncorrectemail";
  user.password="123";
  user.password_confirmation=user.password;
    fill_in "Login", with: user.login;
    fill_in "Email", with: user.email;
    fill_in "Password", with: user.password;
    fill_in "Confirmation", with: user.password_confirmation;
  return user;
  end



