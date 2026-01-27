# frozen_string_literal: true
require 'daemons'

Daemons.run('/home/devops/ffmpeg.rb', log_output: true) do
  STDOUT.sync = true
  STDERR.sync = true
end
