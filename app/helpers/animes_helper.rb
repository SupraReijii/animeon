module AnimesHelper
  def humanize_minutes(minutes)
    return "0 #{t 'anime_helper.minute'}" if minutes.zero?

    hours = (minutes/60).floor.to_i

    if hours > 0
      text = "#{hours} #{t 'anime_helper.hour', count: hours}"
    else
      text = ''
    end

    raw_minutes = minutes % 60
    text += ' ' if hours > 0 && raw_minutes > 0

    if raw_minutes > 0
      if raw_minutes % 10 == 1
        text += "#{raw_minutes} #{t 'anime_helper.minute'}"

      elsif raw_minutes % 10 > 1 && raw_minutes % 10 < 5
        text += "#{raw_minutes} #{t 'anime_helper.minute'}"

      else
        text += "#{raw_minutes} #{t 'anime_helper.minute'}"
      end
    end

    text
  end

  def anime_name_substr(name)
    name.length > 20 ? "#{name[0..20]}..." : name
  end

  def compile_videojs_url(ary)
    u = '['
    ary.to_a.each do |v|
      u += '{"title":  "Озвучка ' + v.fandub.name + '","file": "'
      v.video_url.each do |vu|
        u += "[#{vu.quality}]#{vu.url},"
      end
      u[-1] = '"'
      u += '},'
    end
    u += ']'
    u[-2] = ''
    u.html_safe
  end
end
