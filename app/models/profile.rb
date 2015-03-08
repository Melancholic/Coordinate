VALID_NAME_REGEX = /\A[a-zA-Zа-яА-Я]+\z/i
class Profile < ActiveRecord::Base
  validates(:name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  validates(:second_name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  validates(:middle_name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  has_attached_file :img
  validates_attachment_content_type :img, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  before_save do
    (self.name=self.name.capitalize ) if self.name
    (self.second_name=self.second_name.capitalize ) if self.second_name
    (self.middle_name=self.middle_name.capitalize ) if self.middle_name
  end

end
