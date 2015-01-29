module UzRand
  require 'faker'

  def rand_image
    root_path = Gem::Specification.find_by_name("uzcommon").gem_dir
    File.open(File.join(root_path, "/lib/tasks/random-images/" + rand(1..71).to_s + ".jpg"))
  end

  def rand_file
    root_path = Gem::Specification.find_by_name("uzcommon").gem_dir
    File.open(File.join(root_path, "/lib/tasks/random-files/1.pdf"))
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

  def rand_in_hash(a)    
    a.to_a[rand_int(0, a.length)][0].to_s
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

  def test_post
    '<h3>Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</h3><div><span style="font-weight: bold; font-size: 24px; line-height: 1.1;"><br></span></div><div><span style="font-weight: bold; font-size: 24px; line-height: 1.1;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><span style="font-style: italic; font-size: 24px; line-height: 1.1;"><br></span></div><div><span style="font-style: italic; font-size: 24px; line-height: 1.1;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><span style="text-decoration: underline; font-size: 24px; line-height: 1.1;"><br></span></div><div><span style="text-decoration: underline; font-size: 24px; line-height: 1.1;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><br></div><div><div><span style="font-weight: bold; font-style: italic;"><span style="text-decoration: underline; font-size: 24px; line-height: 1.1;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></span></div></div><div><span style="text-decoration: underline; font-size: 24px; line-height: 1.1;"><br></span></div><div><span style="color: inherit; font-family: inherit; font-size: 18px; line-height: 1.1;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><br></div><div><h4 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</h4></div><div><br></div><div><h4 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);"><span style="font-style: italic;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span></h4></div><div><h4 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);"><br></h4><h4 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);"><span style="text-decoration: underline;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span></h4></div><div><br></div><h5>Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</h5><div><br></div><div><span style="font-weight: bold;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><br></div><div><span style="font-style: italic;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><br></div><div><span style="text-decoration: underline;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><br></div><div><br></div><span style="font-weight: bold; font-style: italic; text-decoration: underline;">Commodi sit id. Pariatur ut soluta corporis in. Maiores dolores eos inventore consequatur quia. Maxime sunt necessitatibus eum praesentium recusandae.</span><div><span style="font-weight: bold; font-style: italic; text-decoration: underline;"><br></span></div><div><span style="font-weight: bold; font-style: italic; text-decoration: underline;"><br></span></div><div><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">left</h5><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Commodi&nbsp;</h5><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">sit id. Pariatur&nbsp;</h5><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">ut soluta corporis in</h5><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Maiores dolores eos&nbsp;</h5><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">inventore&nbsp;</h5></div><div><br></div><div><h5 style="text-align: center; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">center</h5><h5 style="text-align: center; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Commodi&nbsp;</h5><h5 style="text-align: center; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">sit id. Pariatur&nbsp;</h5><h5 style="text-align: center; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">ut soluta corporis in</h5><h5 style="text-align: center; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Maiores dolores eos&nbsp;</h5><h5 style="text-align: center; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">inventore&nbsp;</h5></div><div><br></div><div><h5 style="text-align: right; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">right</h5><h5 style="text-align: right; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Commodi&nbsp;</h5><h5 style="text-align: right; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">sit id. Pariatur&nbsp;</h5><h5 style="text-align: right; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">ut soluta corporis in</h5><h5 style="text-align: right; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">Maiores dolores eos&nbsp;</h5><h5 style="text-align: right; font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);">inventore</h5><h5 style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; color: rgb(51, 51, 51);"><ol><li><span style="line-height: 1.1;">Commodi&nbsp;</span><br></li><li><span style="line-height: 1.1;">sit id. Pariatur&nbsp;</span><br></li><li><span style="line-height: 1.1;">ut soluta corporis in</span><br></li><li><span style="line-height: 1.1;">Maiores dolores eos</span><br></li><li><span style="line-height: 1.1;">inventore&nbsp;</span></li></ol><div><ul><li><span style="line-height: 1.1;">Commodi&nbsp;</span><br></li><li><span style="line-height: 1.1;">sit id. Pariatur&nbsp;</span><br></li><li><span style="line-height: 1.1;">ut soluta corporis in</span><br></li><li><span style="line-height: 1.1;">Maiores dolores eos</span><br></li><li><span style="line-height: 1.1;">inventore&nbsp;</span></li></ul></div></h5></div>'
  end

  def rand_tags(field)
    result = []
    if field.populate.values?
      rand_int(1,5).each do
        result << rand_in_array(field.populate.values)
      end
    else
      rand_int(1,5).each do
        result << rand_tag
      end
    end
  end

  def rand_string(type)
    case type    
    when :title
      Faker::Name.title
    when :name
      Faker::Name.name
    when :email
      Faker::Internet.email
    when :link
      Faker::Internet.url
    when :permalink
      Faker::Name.title.delete(' ').underscore.dasherize
    when :video_link
      rand_video_link      
    when :summary
      Faker::Lorem.sentence(rand_int(1, 3)).titleize.delete('.')      
    when :text
      Faker::Lorem.paragraph(2)
    when :wysi
      Faker::Lorem.paragraph(2)        
    else
      Faker::Lorem.sentence(rand_int(1, 3)).titleize.delete('.')
    end
  end

  def rand_string_value_for_field(field) 
    field_to_s = field.name.to_s     
    type = :string
    if [:email, :permalink, :text, :wysi].include?(field.type)
      type = field.type
    else
      type = :title if field_to_s.include?('title')
      type = :name if field_to_s.include?('name')
      type = :video_link if field_to_s.include?('video') and field_to_s.include?('link')
      type = :summary if field_to_s.include?('summary') or field_to_s.include?('description')
      type = :text if field_to_s.include?('content') or field_to_s.include?('message')
    end
    rand_string(type)
  end

  def rand_value_for_field(field)    
    if [:string, :email, :permalink, :text, :wysi].include?(field.type)
      rand_string_value_for_field(field)
    elsif [:select, :radiogroup].include?(field.type)
      if field.options[:options].is_a?(Hash)
        rand_in_hash(field.options[:options])
      else
        rand_in_array(field.options[:options])
      end
    elsif [:date, :time, :datetime].include?(field.type)
      rand_time      
    else      
      case field.type        
      when :tags
        rand_tags(field)
      when :password
        "test123"
      when :checkbox       
        rand_boolean
      when :money
        rand_decimal * 100      
      when :currency
        rand_decimal
        # when :file
        #   rand_file
      when :image
        rand_image
      when :number
        rand_int        
      else
        ""
      end
    end
  rescue
    print "rand_value_for_field(#{field.name})"
    raise
  end
end
