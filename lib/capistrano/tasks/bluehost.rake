namespace :bluehost do
  desc "create htaccess in public_html directory"
  task :public_html do
    on roles(:app), in: :sequence, wait: 5 do      
      upload! "#{fetch(:local_shared_files_dir)}/public_html_htaccess", "#{fetch(:home_dir)}/public_html/.htaccess"
    end
  end

  desc "create htaccess in shared folder"
  task :create_htaccess_in_shared_folder do
    on roles(:app), in: :sequence, wait: 5 do
      execute "mkdir -p #{shared_path}/public"      
      upload! "#{fetch(:local_shared_files_dir)}/.htaccess", "#{shared_path}/public/.htaccess"
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
end