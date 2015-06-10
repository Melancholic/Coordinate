##
# Модель, хранящая данные о загружаемых изображениях
##
class Image < ActiveRecord::Base
  # Константа, определяющая основные размеры
  # изображений
  SIZES={:icon => "25x25",
      :small  => "50x50",
      :medium => "128x128",
      :normal => "200x200",
      :big => "512x512"}
  has_attached_file :img,
    :styles => SIZES,:whiny_thumbnails => true
  validates_attachment_content_type :img, 
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
    presence: true,
    size: { in: 0..600.kilobytes }
end
