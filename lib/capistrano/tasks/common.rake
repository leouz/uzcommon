

namespace :wn do
  desc "add wn nginx file"
  task :add_nginx_file do
    on roles(:app), in: :sequence, wait: 5 do      
      upload! "#{fetch(:local_shared_files_dir)}/nginx", "/opt/nginx/phd-sites/#{fetch(:application)}-#{fetch(:rails_env)}"      
    end
  end

  desc "add wn nginx file"
  task :restart_nginx do
    on roles(:app), in: :sequence, wait: 5 do      
      execute "sudo /etc/init.d/nginx restart"
    end
  end
end

namespace :deploy do
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
  task :dbreset do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :rake, "db:migrate VERSION=0 RAILS_ENV=#{fetch(:rails_env)}"
        execute :rake, "db:migrate RAILS_ENV=#{fetch(:rails_env)}"
        execute :rake, "db:seed RAILS_ENV=#{fetch(:rails_env)}"
        execute :rake, "db:populate RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  desc "create files in shared folder"
  task :create_shared_files do
    on roles(:app), in: :sequence, wait: 5 do
      execute "mkdir -p #{shared_path}/public"      
      # upload! "#{fetch(:local_shared_files_dir)}/.htaccess", "#{shared_path}/public/.htaccess"
      execute "mkdir -p #{shared_path}/config"      
      upload! "#{fetch(:local_shared_files_dir)}/database.yml", "#{shared_path}/config/database.yml"      
      upload! "#{fetch(:local_shared_files_dir)}/application.yml", "#{shared_path}/config/application.yml"      
    end
  end

  desc "create htaccess in public_html directory"
  task :public_html do
    on roles(:app), in: :sequence, wait: 5 do      
      upload! "#{fetch(:local_shared_files_dir)}/public_html_htaccess", "#{fetch(:home_dir)}/public_html/.htaccess"
    end
  end


  desc "Restarting mod_rails with restart.txt"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute "touch #{current_path}/tmp/restart.txt"
      end
    end
  end  
end

namespace :git do
  task :install do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{fetch(:home_dir)}; export PATH=$HOME/.local/bin:$HOME/.local/usr/bin:$PATH >> .bashrc"
      execute "mkdir -p #{fetch(:home_dir)}.local"
      execute "mkdir -p #{fetch(:home_dir)}.local/src"
      execute "cd #{fetch(:home_dir)}.local/src; wget --no-check-certificate https://github.com/git/git/archive/master.zip"
      execute "cd #{fetch(:home_dir)}.local/src; unzip -o master"
      execute "cd #{fetch(:home_dir)}.local/src; rm master.zip"
      execute "cd #{fetch(:home_dir)}.local/src/git-master; make"
      execute "cd #{fetch(:home_dir)}.local/src/git-master; make install"
    end
  end  
end

namespace :logs do
  desc "tail rails logs" 
  task :tail do
    on roles(:app) do
      # within release_path do
        # execute "tail -f log/#{fetch(:rails_env)}.log"
      # end
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end
end

namespace :shared_files do

end


