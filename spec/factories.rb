FactoryGirl.define do
  factory :user do
    sequence(:login){|n| "user#{n}"}
    sequence(:email){|n| "user#{n}@exmpl.dom"}
    password "password"
    password_confirmation "password"
      
      factory :admin do
        admin true 
      end
    end
    
    factory :VerificationUser do
      verificated true
      verification_key "somekey"
    end
end
