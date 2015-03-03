namespace :db do
  require 'faker'
  require 'uz_rand'
  include UzRand

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
    
    UZ_ADMIN_POPULATE.each do |p|              
      populate_batch(p.constantize.meta)      
    end
  end
end
