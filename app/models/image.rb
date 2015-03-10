class Image < ActiveRecord::Base
  
  has_attached_file :img
  validates_attachment_content_type :img, 
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
    presence: true,
    size: { in: 0..600.kilobytes }
end
