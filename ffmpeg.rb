# frozen_string_literal: true

require 'pg'
require 'streamio-ffmpeg'

i = 0
conn = PG::Connection.new(host: ENV['DATABASE_HOST'], user: 'animeon_dev', password: ENV['DATABASE_PASSWORD'])
while i != -1
  res = conn.exec('SELECT * FROM videos WHERE status = 0 ORDER BY id LIMIT 1').first
  puts res
  unless res.nil?
    id = res['id']
    format = res['video_file_file_name'].match('(.mp4|.avi|.mkv|.mov|.ts)')
    movie = FFMPEG::Movie.new("/mnt/video/#{id}/video-#{id}#{format}")
    if movie.valid?
      res['quality'][1, res['quality'].size - 2].split(',').each do |q|
        Dir.mkdir("/mnt/video/#{id}/#{q.gsub('p', '')}")
      end
      conn.exec("UPDATE videos SET status = 1 WHERE id = #{id}")
      system("sh transcode -i #{id} -f #{format}")
    end
    conn.exec("UPDATE videos SET status = 2 WHERE id = #{id}")
  end
  sleep(5)
  File.read('control').to_s.strip == 'stop' ? i = -1 : i += 1
  puts i
end
