namespace :db do
  require 'faker'
  require 'uz_rand'
  include UzRand

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
      rand_in_array(field.options[:values])
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

  desc "Erase and fill database"
  task :populate => :environment do    
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
