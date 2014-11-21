module UzRand
  require 'faker'

  def rand_image
    root_path = Gem::Specification.find_by_name("uzcommon").gem_dir
    File.open(File.join(root_path, "/lib/tasks/random-images/" + rand(1..71).to_s + ".jpg"))
  end

  def rand_int(from=1, to=100)
    rand_in_range(from, to).to_i
  end

  def rand_decimal(from=10.0, to=99.0)
    rand_in_range(from, to).round(2)
  end

  def rand_time(from=1.month.ago, to=2.months.from_now)      
    Time.at(rand_in_range(from.to_f, to.to_f))
  end

  def rand_in_range(from, to)
    rand * (to - from) + from
  end

  def rand_boolean
    rand_int(0, 1).zero?
  end

  def rand_in_array(a)
    a[rand_int(0, a.length)]
  end

  def rand_tag
    a = %w(aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces)
    rand_in_array(a)
  end

  def rand_video_link
    links = [ 
      "https://www.youtube.com/watch?v=URtRbt7evEA",
      "https://www.youtube.com/watch?v=xBfz_w9fXXs",
      "https://www.youtube.com/watch?v=tlCpp1MrQk0",
      "https://www.youtube.com/watch?v=VPC8Se70nt0",
      "http://vimeo.com/97968548",
      "http://vimeo.com/5696209",
      "http://vimeo.com/35948742",
      "http://vimeo.com/100357962"
    ]
    rand_in_array(links)
  end
end
