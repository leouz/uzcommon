namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do    
    require 'faker'
    @root_path = Gem::Specification.find_by_name("uzcommon").gem_dir
    
    def rand_image
      File.open(File.join(@root_path, "/lib/tasks/random-images/" + rand(1..71).to_s + ".jpg"))
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
        rand_in_array(field.options[:values])
      elsif [:date, :time, :datetime].include?(field.type)
        rand_time
      else      
        case field.type        
        when :password
          "test123"
        when :checkbox
          rand_boolean      
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
    end

    def populate_batch(meta, parent=nil)
      if meta.populate_batch_count.is_a?(Range)
        a = meta.populate_batch_count.to_a
        batch = rand_int(a.first, a.last)
      else
        batch = meta.populate_batch_count
      end
      
      print "\n#{meta.name} batch #{batch}"      
      meta.class.destroy_all if parent == nil
      (1..batch).each do
        result = {}
        meta.form_fields.each do |f|          
          result[f.name] = rand_value_for_field(f)
        end

        if parent != nil
          parent.create(result)
        else        
          created_object = meta.class.create(result)        
          if meta.relationships != nil
            meta.relationships.each do |r|
              print "\n"
              populate_batch(r.meta, created_object.send(r.field))
            end
            print "\n"
          end
          print "."          
        end
      end
      print "\n"
    end

    UZADMIN_METAS.each do |meta|          
      populate_batch(meta)      
    end
  end
end
