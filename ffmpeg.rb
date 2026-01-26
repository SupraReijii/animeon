# frozen_string_literal: true

require 'pg'
require 'streamio-ffmpeg'
require 'redis'
require 'aws-sdk-s3'
require 'dotenv'

Dotenv.load('/home/devops/animeon/.env')
Aws.config.update(
  credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
  region: ENV['S3_REGION'],
  endpoint: ENV['S3_ENDPOINT'],
  force_path_style: true,
  signature_version: 'v4'
)
aws_client = Aws::S3::Client.new
Aws.config.update(logger: Logger.new($stdout), log_level: :debug)

i = 0
conn = PG::Connection.new(host: ENV['DATABASE_HOST'], user: 'animeon', password: ENV['DATABASE_PASSWORD'], port: 54320, dbname: 'animeon_prod')
redis = Redis.new(host: '45.84.1.34', port: ENV['REDIS_PORT'])
redis.set("transcoder:status", "active")
redis.set("transcoder:iterations", "0")
redis.set("transcoder:videos", "0")
redis.set("transcoder:stop", "0")
redis.set("transcoder:current", "0")
redis.set("transcoder:current_time_start", "0")
while i != -1
  res = conn.exec('SELECT * FROM videos WHERE status = 0 ORDER BY id LIMIT 1').first
  puts res
  unless res.nil?
    id = res['id']
    redis.set("transcoder:current", "#{id}")
    format = res['video_file_file_name'].match('(\.mp4|\.avi|\.mkv|\.mov|\.ts)')
    system("sudo -u devops mkdir /transcoding/#{id}")
    aws_client.get_object(
      bucket: 'video',
      key: "#{id}/video-#{id}#{format}",
      response_target: "/transcoding/#{id}/video-#{id}{format}"
    )
    movie = FFMPEG::Movie.new("/transcoding/#{id}/video-#{id}#{format}")
    if movie.valid?
      conn.exec("UPDATE videos SET status = 1 WHERE id = #{id}")
      redis.set("transcoder:status", "transcoding")
      redis.set("transcoder:current_time_start", Time.now.to_s)
      time_start = Time.now
      system("sh /home/devops/transcode -i #{id} -f #{format.to_s.gsub('.', '')}")
      time_end = (Time.now - time_start).round(0)
      system("aws s3 cp --recursive /transcoding/#{id} s3://video/#{id}")
      redis.set("transcoder:video:#{redis.get("transcoder:videos_all_time")}:time",
                time_end.to_s)
      redis.set("transcoder:video:#{redis.get("transcoder:videos_all_time")}:id",
                id.to_s)
      redis.set("transcoder:videos_all_time_transcoding_time",
                "#{(redis.get("transcoder:videos_all_time_transcoding_time").to_i + time_end)}")
    end
    conn.exec("UPDATE videos SET status = 2 WHERE id = #{id}")
    redis.incr("transcoder:videos")
    redis.incr("transcoder:videos_all_time")
    redis.set("transcoder:current_time_start", "0")
    redis.set("transcoder:current", "0")
    redis.set("transcoder:status", "active")
    #system("rm -r /transcoding/#{id}")
  end
  sleep(5)
  redis.get("transcoder:stop") == "1" ? i = -1 : i += 1
  redis.incr("transcoder:iterations")
end
redis.set("transcoder:status", "stopped")
