namespace :digital_ocean do
  desc "create nginx file"
  task :create_nginx_file do
    on roles(:app), in: :sequence, wait: 5 do      
      upload! "#{fetch(:local_shared_files_dir)}/nginx.conf", "#{fetch(:nginx_conf_dir)}/#{fetch(:rails_env)}_#{fetch(:application)}.conf"      
    end
  end
end