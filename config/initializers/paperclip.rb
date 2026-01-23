# frozen_string_literal: true

Paperclip::DataUriAdapter.register
Paperclip::HttpUrlProxyAdapter.register
Paperclip.options[:content_type_mappings] = {
  mkv: ['video/x-matroska', 'application/x-matroska']
}
Paperclip::Attachment.default_options.merge!(
  storage: :s3,
  s3_region: ENV["S3_REGION"],
  s3_host_name: 's3.animeon.ru',
  s3_credentials: {
    access_key_id:     ENV["ACCESS_KEY_ID"],
    secret_access_key: ENV["SECRET_ACCESS_KEY"],
    s3_region:         ENV["S3_REGION"],
    s3_host_name: 's3.animeon.ru'
  },
  s3_permissions: :"public-read", # или :"public-read"
  s3_protocol: "https",
  path: "uploads/:class/:attachment/:id_partition/:style/:filename"
)
