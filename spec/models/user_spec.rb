require 'rails_helper'

describe User do
  before { @user = User.new(login: "Example", email:"user@example.com", 
    password: "foobar",password_confirmation:"foobar" )}
  subject {@user}
  #тест наличия
  it{ should respond_to(:login) }
  it{ should respond_to(:email) }
  it{ should respond_to(:password_digest) }
  it{ should respond_to(:password) }
  it{ should respond_to(:password_confirmation) }
  it{ should respond_to(:authenticate) }
  it{ should respond_to(:admin) }
  it{should respond_to(:verification_user)}
  it{should respond_to(:verificated?)}
  it {should respond_to(:verification_key)}
#тесты на связь с reset_passwords
it {should respond_to(:reset_password)}
it {should respond_to(:reset_password_key)}
it {should respond_to(:make_reset_password)}


it {should respond_to(:profile)}
it {should respond_to(:full_name)}
it {should respond_to(:short_name)}
it {should respond_to(:admin_display_name)}
it {should respond_to(:name)}
it {should respond_to(:name=)}
it {should respond_to(:second_name)}
it {should respond_to(:second_name=)}
it {should respond_to(:middle_name)}
it {should respond_to(:middle_name=)}
it {should respond_to(:avatar)}
it {should respond_to(:avatar?)}
it {should respond_to(:avatar=)}
it {should respond_to(:second_name)}
it {should respond_to(:second_name=)}

it {should respond_to(:cars)}
it {should respond_to(:create_car)}




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

  describe "login is null: " do
    before{@user.login=" "}
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
describe "login is too long" do
  before{@user.login='x'*16}
  it {should_not be_valid}
end
describe "login is too short" do
  before{@user.login="xx"}
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

  #тест валидности login
  describe "login is INVALID" do
    it "should be invalid" do
      emails = %w[corr712*
        &7&sq7
        ??qaq?
        @@@qwe
        !!q"'
        122123]
        emails.each do |inv_ems|
          @user.login = inv_ems;
          expect(@user).not_to be_valid
        end
      end
    end
    describe "login is VALID" do
      it "should be valid" do
        emails = %w[12aa
          NanasHs
          HHUU
          YAGs-as
          sfggy_Fty]
          emails.each do |inv_ems|
            @user.login = inv_ems;
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

describe "create car is valid" do
  let(:user){FactoryGirl.create(:user)}
  before {user.create_car(title:"car1")}
  it {expect(user.cars.first).to eq Car.find_by(title:"car1")}
  it {expect(ApiToken.count).to eq 1}
  it {expect(user.cars.first.api_token.car).to eq user.cars.first}  
end

describe "delete car is valid" do
  let(:user){FactoryGirl.create(:user)}
  before  do
    user.create_car(title:"car1")
    user.create_car(title:"car2")
  end
  it {expect(user.cars.count).to eq 2 }
  it {expect(ApiToken.count).to eq 2}
  subject { -> {user.cars.first.destroy} }
  it { should change(Car, :count).by(-1) }
  it { should change(ApiToken, :count).by(-1) }
end

describe "delete ApiToken is valid" do
  let(:user){FactoryGirl.create(:user)}
  before  do
    user.create_car(title:"car1")
    user.create_car(title:"car2")
  end
  it {expect(user.cars.count).to eq 2 }
  subject { -> {user.cars.first.api_token.destroy} }
  it { should change(Car, :count).by(0) }
  it { should change(ApiToken, :count).by(-1) }
  it {expect(user.cars.count).to eq 2 } 
end
end
