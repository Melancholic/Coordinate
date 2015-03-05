require 'rails_helper'

describe "UsersPages" do
  subject{ page }
  #Тесты страныцы пользователей User#Index
  
  describe "Index" do
    let (:user){FactoryGirl.create(:user)}
    before do
      sign_in user
      verificate user
      visit users_path

    end

    it{should have_title('Users')}
    it{should have_content(' All users')}


  #Тесты пагинации
    describe "pagination" do
      before(:all){50.times{FactoryGirl.create(:user)}}
      it{should have_title('Users')}

      it 'should list each user' do
       # User.paginate(page: 1).each do |user|
       #   expect(page).to have_selector('li',text: user.login)
       # end
      end
    end
  end

  # Тесты регистрации
  describe "Sign Up page" do
  before { visit signup_path }
    it { should have_content('Sign up') }
    it { should have_field('user_login') }
    it { should have_field('user_email') }
    it { should have_field('user_password') }
    it { should have_field('user_password_confirmation') }
    it { should have_title(full_title("Registration"))}
  end

  let(:user) {FactoryGirl.create(:user)}
  before do
   # Capybara.default_driver = :selenium
    visit signin_path
  end
  it{ should have_title(full_title('Sign in'))}
# тесты восстановления пароля
    let(:rst_lnk){"Forgot your password?"}
    describe "have reset password link" do
      it do 
        within(".container") do
          should have_link(rst_lnk,reset_password_users_path)
        end
      end
      describe"click reset-password link" do
        before do
          within('.container') {click_link(rst_lnk)};
        end
          it{should have_title(full_title('Reset Password'))};
          it{should have_content('Please check your e-mail!')};
          it{should have_field('email')};
          it{should have_button('Send instructions')};
        describe "send email" do
        
          it{should have_title(full_title('Reset Password'))};
          describe "non fill" do
            before do
              click_button('Send instructions')
            end
            it{should have_content("User with e-mail: not found!")};
            it{should have_title(full_title('Reset Password'))};
          end
          describe "uncorrect fill" do
            before{
              fill_in "email", with: "unknowawd";
              click_button('Send instructions'); 
            }
            it{should have_content("User with e-mail: unknowawd not found!")};
            it{should have_title(full_title('Reset Password'))};
          end
          describe "correct fill" do
            before{
              within('.container') {fill_in "email", with: user.email};
            }
            
            it "e-mail" do 
              expect {click_button('Send instructions')}.to change(ResetPassword, :count); 
              should have_title(full_title(''));
              puts body
              should have_content("Mail with instructions has been sended to e-mail: #{user.email}!");
              should have_selector('div.alert.alert-success')

            end
          end
            describe "in reset_password controller" do
                let(:rp){user.make_reset_password(host:"127.0.0.1")}
              it{
                expect(rp.host).to eq("127.0.0.1")
                expect(user).to eq(ResetPassword.get_user(rp))
                expect(user).to eq(ResetPassword.get_user(user.reset_password_key))
                expect(user).to eq(rp.get_user)
                expect(user.reset_password.password_key).to eq(ResetPassword.get_user(rp).reset_password_key)
                expect(user.reset_password.password_key).to eq(rp.password_key)
              }
            describe "go to reset_password path with key param" do
              describe "in the future" do
                before{
                  Timecop.travel(rp.updated_at+1.day);
                  visit reset_password_users_path(key:rp.password_key)
                }
                it{
                  should have_title(full_title('Reset Password'));
                  should have_content("The lifetime of this reference completion. Please try the request again.");
                  should have_selector('div.alert.alert-error')
                  should have_content('Please check your e-mail!');
                  should have_content('E-mail');
                  should have_button('Send instructions');
                  should have_field('email');
             #     Timecop.return;
                }
                after{Timecop.return;}
              end
              describe "in the now" do
                before{
                  visit reset_password_users_path(key:rp.password_key)
                }
                it{
                  should have_title(full_title('Reset Password'));
                  should have_button('Reset password');
                  should have_field('user_password');
                  should have_field('user_password_confirmation');
                }
              end
              describe "fill uncorrect data" do
                before{
                  
                  visit reset_password_users_path(key:rp.password_key)
                  within ('.container') do
                    fill_in 'user_password', with:"qwe"
                    click_button 'Reset password'
                  end
                }
                it{
                  should have_title(full_title('Reset Password'));
                  should have_button('Reset password');
                  should have_field('user_password');
                  should have_field('user_password_confirmation');
                  should have_selector('div.alert.alert-error');
                  should have_content('Password confirmation doesn\'t match Password');
                  should have_content('Password is too short (minimum is 6 characters)');
                }
              end
              describe "fill correct data" do
                let(:pass){"123456correct_pas"}
                before{
                  visit reset_password_users_path(key:rp.password_key)
                  within ('.container') do
                    fill_in 'user_password', with:pass;
                    fill_in 'user_password_confirmation', with:pass;
                    click_button 'Reset password'
                  end
                  user.reload;
                }
                it{
                  should have_title(full_title(''));
                  should have_selector('div.alert.alert-succes');
                  should have_content('Updating your profile is success');
                  expect(user).to eq(user.authenticate(pass));
                }
              end
            end
          end
      end
        #before{fill_in(user.email,"email")}       
        
      end
    end
#Тесты регистрации
#невалидные данные
  describe "Signup page" do
    before {visit root_path}
    let (:submit) {"Sign up"}
    describe "with invalid data" do
      it "should not create a user" do
        within (".new_user") do
          expect {click_button(submit)}.not_to change(User, :count)
        end
      end
      describe "after submission" do
        before {
          within (".new_user") do
            click_button submit
          end
        }
        it{should have_title(full_title('Registration'))};
        it{should have_content('Please review the problems below:')};
        specify{page.all(:css,'span.help-block', text:'can\'t be blank').length == 3}
        specify{page.all(:css,'span.help-block', text:"doesn't match Password").length == 1}

        end
    end
#проверка ошибок
    
#валидные данные
    describe "with valid data" do
       let!(:user_notv){FactoryGirl.create(:user)}

      before do
        visit signin_path
        within ("#new_user") do
          setValidUsersData(user_notv)
        end
      end
      it "should create a user" do
        within ("#new_user") do
          expect {click_button(submit)}.to change(User, :count).by(1)
        end
      end
      describe "after signup" do
        before do
        within ("#new_user") do
            click_button submit
        end
        end
        let!(:usr){User.find_by(email: user_notv.email)}
        it{should have_link("Sign Out") }
        it{should have_title(full_title("Verification"))}
      end
    end
#Подтверждение email

  describe "Test Verificated" do
   let (:notf_u){FactoryGirl.create(:user)}
    before {sign_in notf_u}
    describe"at verificate page" do
      it{should have_title(full_title "Verification")}
       describe  "should not acces to /users"do
        before{visit(users_path)}
        it{should have_title(full_title "Verification")}
       end 
       describe  "should not acces to user#show"do
        before{visit(user_path(notf_u))}
        it{should have_title(full_title "Verification")}
       end
       describe  "should not acces to home"do
          before{visit root_url}
          it{should have_title(full_title "Verification")}
        end
       describe  "should have acces to user#edit"do
        before{visit(edit_user_path(notf_u))}
        it{should have_title("Edit profile")}
       end
    end
  end 
# Тесты  обновления пользователей
    describe 'edit profile ' do
      let(:user) {FactoryGirl.create(:user)}
      before do
      sign_in(user)
      verificate user
      visit edit_user_path(user)
      end

      describe 'at page' do 
        it{should have_content('Update your profile')}
        it{should have_title(full_title("Edit profile"))}
        it{should have_link('Change Gravatar',href:'http://gravatar.com/emails')}
      end
      describe 'with invalid data' do
        before do
          setInvalidUsersData(user)
          click_button "Save"
        end
        it { should have_content('error')}
        it {should have_content('Update your profile')}
        it{should have_title(full_title("Edit profile"))}  
        specify {expect(user.login).not_to eq user.reload.login}
        specify {expect(user.email).not_to eq user.reload.email} 
      end
      describe 'with valid data' do
        before do
          setValidUsersData(user)
          click_button "Save"
        end
        it {should have_content('Updating your profile is success')}
        specify {expect(user.login).to eq user.reload.login}
        specify {expect(user.email).to eq user.reload.email} 
     end
     #Тест на запрет установки admin с http запроса
    describe "forbidden attributes" do 
      let(:params) do
        {user:{admin:true, password: user.password, password_confirmation:user.password} }
      end
      before do
        sign_in(user,no_capybara:true)
        patch(user_path(user),params)
      end
      specify{expect(user.reload() ).not_to be_admin}
    end
    
    # Тест на запрет  к NEW и CREATE  для зарегистрированных пользователей 
    describe "go to create new account page" do
      before { visit(new_user_path)}
      it{should have_title(full_title(''))}
      
      let(:wrong_usr){FactoryGirl.create(:user,email: "wrong@email.dom")}
      before{get new_user_path(wrong_usr)}
      specify{expect(response.body).to match(full_title('Home'))}

    end
  end
end

# Тест профиля
  describe "profile page" do
    let(:user) {FactoryGirl.create(:user)}

    before do
      sign_in user
      verificate user
      visit user_path(user)
    end
  end

end

