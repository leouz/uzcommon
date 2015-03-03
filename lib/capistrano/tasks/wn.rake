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