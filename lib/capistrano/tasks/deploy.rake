namespace :deploy do
  namespace :db do
    desc "reload the database with seed data"
    task :seed do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute :rake, "db:seed RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    desc "reload the database with populate data"
    task :populate do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute :rake, "db:populate RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    desc "reload the database with migrate data"
    task :migrate do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute :rake, "db:migrate RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    desc "reset database"
    task :reset do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute :rake, "db:migrate VERSION=0 RAILS_ENV=#{fetch(:rails_env)}"
          execute :rake, "db:migrate RAILS_ENV=#{fetch(:rails_env)}"
          execute :rake, "db:seed RAILS_ENV=#{fetch(:rails_env)}"
          execute :rake, "db:populate RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    desc "create database"
    task :create do
      on roles(:app), in: :sequence, wait: 5 do
        within release_path do
          execute :rake, "db:create RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end
  end

  %w[database application].each do |file|
    desc "create #{file}.yml file"
    task "create_#{file}_file" do
      on roles(:app), in: :sequence, wait: 5 do      
        execute "mkdir -p #{shared_path}/config"      
        upload! "#{fetch(:local_shared_files_dir)}/#{file}.yml", "#{shared_path}/config/#{file}.yml"        
      end
    end
  end

  desc "Restarting mod_rails with restart.txt"
  task :restart_mod_rails do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute "touch #{current_path}/tmp/restart.txt"
      end
    end
  end  
end