require 'rails_helper'

describe User do
  before { @user = User.new(name: "Example", email:"user@example.com", 
          password: "foobar",password_confirmation:"foobar" )}
  subject {@user}
  #тест наличия
  it{ should respond_to(:name) }
  it{ should respond_to(:email) }
  it{ should respond_to(:password_digest) }
  it{ should respond_to(:password) }
  it{ should respond_to(:password_confirmation) }
  it{ should respond_to(:authenticate) }
  it{ should respond_to(:admin) }
  # Тест связи с microposts
  it{ should respond_to(:microposts)}
  it{should respond_to(:replics_from)}
  # Тест связи с relationships
  it{should respond_to(:relationships) }

  it {should respond_to(:followed_users)}              
  #Тесты читаемых пользователей, данным пользователем

  it{should respond_to(:following?)}
  it{should respond_to(:follow!)}

  it{should respond_to(:verification_user)}
  it{should respond_to(:verificated?)}
  it {should respond_to(:verification_key)}
#тесты на связь с reset_passwords
  it {should respond_to(:reset_password)}
  it {should respond_to(:reset_password_key)}
  it {should respond_to(:make_reset_password)}

  describe "following" do
    let(:other_user){FactoryGirl.create(:user)}
    before do
      @user.save;
      @user.follow!(other_user);
    end
    it {should be_following(other_user)}
    it {expect(@user.followed_users).to include(other_user)}
    describe "followed user" do
      subject{other_user}
      it {expect(other_user.followers).to include(@user)}
    end
    describe "end unfollowing" do
      before {@user.unfollow!(other_user)}
        it {should_not be_following(other_user)}
        it {expect(@user.followed_users).not_to include(other_user)}
    end
  end

  #Тесты  администратора
  it{should_not be_admin}
  describe "admin flag set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it{should be_admin}
  end
   
  #тест валидности
  it { should be_valid }

  describe "name is null: " do
    before{@user.name=" "}
    it {should_not be_valid}
  end
  describe "email is null" do
    before{@user.email=" "}
    it {should_not be_valid}
  end
  describe "password is null" do
    before{@user.password=@user.password_confirmation=" "}
    it {should_not be_valid}
  end
  describe "password is doesnt match confirmation" do
    before{@user.password_confirmation="anotherpass"}
    it {should_not be_valid}
  end
#тест длины
  describe "name is too long" do
    before{@user.name='x'*16}
    it {should_not be_valid}
  end
  describe "name is too short" do
    before{@user.name="xx"}
    it { should_not be_valid }
  end  
  describe "email is too long" do
    before{@user.email='x'*51}
    it {should_not be_valid}
  end
  describe "email is too short" do
    before{@user.email="xx"}
    it { should_not be_valid }
  end
  #тест валидности email
  describe "email is INVALID" do
    it "should be invalid" do
      emails = %w[corr-ect@cs.ru.
                cor*.ra+ect@cs.ru
                corrA.ect@c&&sa.ru
                corr/ect@cs.ru
                corr-ect|76cs.ru
                corr-ectqcas.ru
                asdasd@aa..ru]
      emails.each do |inv_ems|
        @user.email = inv_ems;
        expect(@user).not_to be_valid
      end
    end
  end
  describe "email is VALID" do
    it "should be valid" do
      emails = %w[Cpq-ect@cs.ru
                corr.ect@cs.ru
                cAF_fwe-qwet@cs.ru
                cor+r_ect@cs.ru
                corr.123@ec12.t12.ru
                corr-ect@qcs.ru
                assdd@asd.af]
      emails.each do |inv_ems|
        @user.email = inv_ems;
        expect(@user).to be_valid
      end
    end
  end

  #тест валидности name
  describe "name is INVALID" do
    it "should be invalid" do
      emails = %w[corr712*
                  &7&sq7
                  ??qaq?
                  @@@qwe
                  !!q"'
                  122123]
      emails.each do |inv_ems|
        @user.name = inv_ems;
        expect(@user).not_to be_valid
      end
    end
  end
  describe "name is VALID" do
    it "should be valid" do
      emails = %w[12aa
                  NanasHs
                  HHUU
                  YAGs-as
                  sfggy_Fty]
      emails.each do |inv_ems|
        @user.name = inv_ems;
        expect(@user).to be_valid
      end
    end
  end
  #тест на уникальность email
  describe "email is already taken" do
    before do
      user_dupUP=@user.dup;
      user_dupUP.email=@user.email.upcase;
      user_dupUP.save;
    end
    it {should_not be_valid}
  end
#тест на успешную аунтефикацию
  it{should respond_to(:authenticate)}
  describe "return user from authenticate" do
    before{@user.save()}
    let(:found_user){User.find_by(email: @user.email)}
    describe "with valid password" do
      it{should eq found_user.authenticate(@user.password)}
    end
    describe "with invalid password" do
      let(:user_for_invalid_passwd){found_user.authenticate("invalid")}
      it { should_not eq user_for_invalid_passwd }
      it {expect(user_for_invalid_passwd).to eq false}
    end
  end

#Тест на длину пароля
   describe "password is too short" do
    before{@user.password = @user.password_confirmation="xx"}
    it { should_not be_valid }
  end

#Тесты для сессии
    describe "remember token is valid" do
    subject(:user){@user}
      #it {should respond_to (:remember_token)}
      before {@user.save}
        it {expect(@user.remember_token).not_to eq be_blank}
    end
# Тесты ассоциации с micropost
    describe "micropost associations" do
      before{@user.save}
        let!(:older_micropost) do
          FactoryGirl.create(:micropost,user: @user, created_at: 5.day.ago)
        end
        let!(:newer_micropost) do
          FactoryGirl.create(:micropost,user: @user, created_at: 5.hour.ago)
        end

        it "should have right micropost in the right order" do
          expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
        end

        #Тест на уничтожение сообщений при удалении пользователей 
        it "should destroy associated microposts" do
          microposts=@user.microposts.to_a
          @user.destroy
          expect(microposts).not_to be_empty
          microposts.each do |mpost|
            expect(Micropost.where(id:mpost.id)).to be_empty
          end
        end
        describe "status" do
          let(:unfollowed_post) do
            FactoryGirl.create(:micropost, user:FactoryGirl.create(:user))
          end

          let(:followed_user) {FactoryGirl.create(:user)}

          before do
            @user.follow!(followed_user)
            3.times{followed_user.microposts.create!(content: "Text text Text")}
          end
          it{expect(@user.feed).to include(newer_micropost)}
          it{expect(@user.feed).to include(older_micropost)}
          it{expect(@user.feed).not_to include(unfollowed_post)}
          it do
            followed_user.microposts.each do |post|
              expect(@user.feed).to include(post)
            end
          end
        end
    end
end
