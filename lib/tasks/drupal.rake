# -*- coding: utf-8 -*-
require 'yaml'
drupal_settings = YAML.load_file('config/drupal.yml')

namespace :drupal do
  desc "Get db from remote drupal site and save it to file"
  task :get_db do
    h = drupal_settings['old_site_hosting']
    system "ssh #{h['user']}@#{h['host']} mysqldump --user=#{h['mysql_user']} --pass=#{h['mysql_pass']} --host=#{h['mysql_host']} #{h['mysql_db']} > tmp/drupal_db_from_live.sql"
  end

  desc "Apply db dump to local db from file, which was created in :get_db"
  task :apply_db do
    db = drupal_settings['database']
    system <<-CMD
      TABLES=$(mysql --user=#{db['user']} --pass=#{db['pass']} --host=#{db['host']} #{db['db']} -e 'show tables' | awk '{ print $1}' | grep -v '^Tables' )

      for t in $TABLES
      do
	echo "Deleting $t table..."
	mysql --user=#{db['user']} --pass=#{db['pass']} --host=#{db['host']} #{db['db']} -e "drop table $t"
      done
    CMD

    puts "\n\nFilling database from dump..."

    system "mysql --user=#{db['user']} --pass=#{db['pass']} --host=#{db['host']} #{db['db']} --execute='source tmp/drupal_db_from_live.sql'"
  end

  desc "Run drupal:get_db and drupal:apply_db"
  task :sync_db do
    Rake::Task[ "drupal:get_db"].execute
    Rake::Task[ "drupal:apply_db"].execute
  end

  desc "Get files from remote drupal"
  task :get_files do
    h = drupal_settings['old_site_hosting']
    exclude = ''
    ['/languages/', '/xmlsitemap/', '/imagecache/', '/backup_migrate/', '/fivestar/', '/imagefield_*/'].each do |e|
      exclude << "--exclude=#{e} "
    end
    system "rsync -rlcv #{h['user']}@#{h['host']}:projects/bsuir-helper/htdocs/sites/default/files/ tmp/drupal_files/ #{exclude} --delete"
  end

  namespace :import do
    desc "Import users from drupal database"
    task :users => :environment do
      require 'digest/md5'
      class DrupalConnect < ActiveRecord::Base
        drupal_settings = YAML.load_file('config/drupal.yml')
        establish_connection(
          :adapter  => "mysql",
          :host     => drupal_settings['database']['host'],
          :username => drupal_settings['database']['user'],
          :password => drupal_settings['database']['pass'],
          :database => drupal_settings['database']['db'],
          :encoding => "utf8"
        )
      end

      class DrupalUser < DrupalConnect
        set_table_name "users"
      end

      users = DrupalUser.all
      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      users_counter = 0
      error_users_counter = 0
      users.each do |drupal_user|
        if drupal_user.uid != 0 && !User.first(:conditions => {:drupal_uid => drupal_user.uid})
          user = User.new
          user.login = drupal_user.name
          user.email = drupal_user.mail
          pass = Digest::MD5.hexdigest(drupal_user.pass)
          user.password = pass
          user.password_confirmation = pass
          user.last_request_at = Time.at(drupal_user.access) if drupal_user.access > 0
          user.last_login_at = Time.at(drupal_user.login) if drupal_user.login > 0
          user.created_at = Time.at(drupal_user.created) if drupal_user.created > 0
          user.college = @bsuir
          user.active = drupal_user.status

          # user.first_name = drupal_user.
          # user.last_name = drupal_user.
          # user.gender = drupal_user.
          # user.birthday = drupal_user.
          # user.city = drupal_user.
          # user.twitter = drupal_user.
          # user.jabber = drupal_user.
          # user.skype = drupal_user.
          # user.icq = drupal_user.
          # user.description = drupal_user.
          # user.faculty = drupal_user.
          # user.speciality = drupal_user.
          # user.loved_discipline = drupal_user.
          # user.unloved_discipline = drupal_user.

          if !drupal_user.picture.blank?
            avatar = drupal_user.picture.sub(/sites\/default\/files/, 'tmp/drupal_files')
            user.avatar = File.open(avatar) if File.exist?(avatar)
          end

          user.drupal_uid = drupal_user.uid
          user.drupal_pass = drupal_user.pass

          if user.save
            users_counter += 1
          else
            error_users_counter += 1
            puts "Ошибка с #{drupal_user.uid} #{drupal_user.name}"
            puts user.errors.to_a.collect { |e| e.join(": ") }.join("\n")
          end
        end# if drupal_user.uid != 0 ...
      end# users.each do |drupal_user|
      puts "Было проимпортированно #{users_counter}. С ошибками: #{error_users_counter}"
    end# drupal:import:users
  end# drupal:import
end# drupal
