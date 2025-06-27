require File.expand_path(File.dirname(__FILE__) + '/../config/boot')
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
module Clockwork
  every 5.seconds, 'ShikiParser' do
    ShikiParserWorker.perform_async
  end
  every 5.minutes, 'OngoingParser' do
    OngoingParserWorker.perform_async
  end
end
