# frozen_string_literal: true

Paperclip::DataUriAdapter.register
Paperclip::HttpUrlProxyAdapter.register
Paperclip.options[:content_type_mappings] = {
  mkv: ['video/x-matroska', 'application/x-matroska']
}
