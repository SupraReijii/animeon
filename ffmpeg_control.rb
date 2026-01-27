# frozen_string_literal: true
require 'daemons'

Daemons.run('/home/devops/ffmpeg.rb', logfilename: '/home/devops/transcoder.log')
