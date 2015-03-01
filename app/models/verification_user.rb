class VerificationUser < ActiveRecord::Base
  before_create{
    srand
    seed = "--#{rand(10000)}--#{Time.now}--"
    self.verification_key= Digest::SHA1.hexdigest(seed)[0,30];
  }
end
