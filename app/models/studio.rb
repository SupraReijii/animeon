class Studio < ApplicationRecord
  has_attached_file :image,
                    url: '/files/images/:style/:id.:extension',
                    path: ':rails_root/public/files/images/studios/:style/:id.:extension'
  validates_attachment_content_type :image, content_type: /\Aimage/
end
