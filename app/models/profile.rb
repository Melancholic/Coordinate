VALID_NAME_REGEX = /\A[a-zA-Zа-яА-Я]+\z/i
class Profile < ActiveRecord::Base
  belongs_to :image, dependent: :destroy;
  accepts_nested_attributes_for :image, update_only: true, :reject_if => proc { |attributes| attributes['img'].blank? }, :allow_destroy => true

  validates(:name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  validates(:second_name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  validates(:middle_name, length:{maximum:20}, absence: false ,format: {with: VALID_NAME_REGEX},allow_blank: true );
  before_save do
    (self.name=self.name.capitalize ) if self.name
    (self.second_name=self.second_name.capitalize ) if self.second_name
    (self.middle_name=self.middle_name.capitalize ) if self.middle_name
  end

end
