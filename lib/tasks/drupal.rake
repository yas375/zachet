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
      require 'php_serialize'
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
        has_many :drupal_profile_values, :foreign_key => :uid, :primary_key => :uid
      end

      class DrupalProfileValue < DrupalConnect
        set_table_name "profile_values"
        belongs_to :drupal_user
      end

      users = DrupalUser.all(:include => :drupal_profile_values )
      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      users_counter = 0
      error_users_counter = 0
      users.each do |drupal_user|
        if drupal_user.uid != 0
          details = drupal_user.drupal_profile_values

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

          user.first_name = details.detect { |i| i.fid == 13}.try(:value) || ''
          user.last_name = details.detect { |i| i.fid == 12}.try(:value) || ''

          user.gender = case details.detect { |i| i.fid == 8}.try(:value)
                          when 'мужской' then :male
                          when 'женский' then :female
                          when 'паркетный' then :parquet
                          else nil
                        end
          bday_serialized = details.detect { |i| i.fid == 7}.try(:value)
          if bday_serialized
            if !(bday = PHP.unserialize(bday_serialized)).nil?
              user.birthday = Date.parse("#{bday['month']}/#{bday['day']}/#{bday['year']}") if bday['year'].to_i < 1998
            end
          end
          user.city = details.detect { |i| i.fid == 6}.try(:value) || ''
          user.twitter = details.detect { |i| i.fid == 14}.try(:value) || ''
          user.jabber = details.detect { |i| i.fid == 15}.try(:value) || ''
          user.skype = details.detect { |i| i.fid == 5}.try(:value) || ''
          user.icq = details.detect { |i| i.fid == 4}.try(:value) || ''
          user.description = details.detect { |i| i.fid == 9}.try(:value) || ''
          user.faculty = details.detect { |i| i.fid == 1}.try(:value) || ''
          user.speciality = details.detect { |i| i.fid == 2}.try(:value) || ''
          user.loved_discipline = details.detect { |i| i.fid == 10}.try(:value) || ''
          user.unloved_discipline = details.detect { |i| i.fid == 11}.try(:value) || ''

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

    desc "Import disciplines from drupal database"
    task :disciplines => :environment do
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

      class DrupalTermData < DrupalConnect
        set_table_name "term_data"
      end

      disciplines = DrupalTermData.all(:conditions => {:vid => 2})
      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      disciplines_counter = 0
      error_disciplines_counter = 0
      disciplines.each do |drupal_discipline|
        discipline = Discipline.new

        if drupal_discipline.description.blank?
          discipline.name = drupal_discipline.name
        else
          discipline.name = drupal_discipline.description
        end
        discipline.abbr = drupal_discipline.name
        discipline.college = @bsuir
        discipline.drupal_tid = drupal_discipline.tid

        if discipline.save
          disciplines_counter += 1
        else
          error_disciplines_counter += 1
          puts "Ошибка с #{drupal_discipline.tid} #{drupal_discipline.name}"
          puts discipline.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end
      end# disciplines.each do |drupal_user|
      puts "Было проимпортированно #{disciplines_counter}. С ошибками: #{error_disciplines_counter}"
    end# drupal:import:disciplines
  end# drupal:import
end# drupal