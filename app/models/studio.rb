class Studio < ApplicationRecord
  has_attached_file :image,
                    bucket: 'studio-images',
                    path: ':id.:extension'
  validates_attachment_content_type :image, content_type: /\Aimage/
end
