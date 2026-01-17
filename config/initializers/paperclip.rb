# frozen_string_literal: true

Paperclip::DataUriAdapter.register
Paperclip::HttpUrlProxyAdapter.register
Paperclip.options[:content_type_mappings] = {
  mkv: ['video/x-matroska', 'application/x-matroska']
}


Paperclip::Attachment.default_options[:storage] = :s3
Paperclip::Attachment.default_options[:s3_credentials] = {
  bucket: 'video',
  access_key_id: ENV['ACCESS_KEY_ID'],
  secret_access_key: ENV['SECRET_ACCESS_KEY'],
  region: 'Zone_1'
}
Paperclip::Attachment.default_options[:s3_options] = {
  endpoint: "https://s3.animeon.ru",
  force_path_style: true
}
# Required for newer versions of aws-sdk-s3
Paperclip::Attachment.default_options[:s3_region] = 'Zone_1'
Paperclip::Attachment.default_options[:s3_host_name] = 's3.animeon.ru'
Paperclip::Attachment.default_options[:s3_protocol] = 'https'
