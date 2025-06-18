require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
module Clockwork
  every 30.seconds, 'ShikiParser' do
    ShikiParserWorker.perform_async
  end
end
