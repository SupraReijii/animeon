# frozen_string_literal: true

require 'pg'
require 'streamio-ffmpeg'
require 'redis'

i = 0
conn = PG::Connection.new(host: ENV['DATABASE_HOST'], user: 'animeon_prod', password: ENV['DATABASE_PASSWORD'])
redis = Redis.new(host: '45.84.1.34', password: ENV['REDIS_PASSWORD'])
redis.set("transcoder:status", "active")
redis.set("transcoder:iterations", "0")
redis.set("transcoder:videos", "0")
redis.set("transcoder:stop", "0")
redis.set("transcoder:current", "0")
while i != -1
  res = conn.exec('SELECT * FROM videos WHERE status = 0 ORDER BY id LIMIT 1').first
  puts res
  unless res.nil?
    id = res['id']
    redis.set("transcoder:current", "#{id}")
    format = res['video_file_file_name'].match('(\.mp4|\.avi|\.mkv|\.mov|\.ts)')
    movie = FFMPEG::Movie.new("/mnt/video/#{id}/video-#{id}#{format}")
    if movie.valid?
      res['quality'][1, res['quality'].size - 2].split(',').each do |q|
        Dir.mkdir("/mnt/video/#{id}/#{q.gsub('p', '')}")
      end
      conn.exec("UPDATE videos SET status = 1 WHERE id = #{id}")
      redis.set("transcoder:status", "transcoding")
      system("sh transcode -i #{id} -f #{format}")
    end
    conn.exec("UPDATE videos SET status = 2 WHERE id = #{id}")
    redis.incr("transcoder:videos")
    redis.set("transcoder:current", "0")
    redis.set("transcoder:status", "active")
  end
  sleep(5)
  redis.get("transcoder:stop") == "1" ? i = -1 : i += 1
  redis.incr("transcoder:iterations")
end
redis.set("transcoder:status", "stopped")
