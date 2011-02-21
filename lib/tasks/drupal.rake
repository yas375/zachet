# -*- coding: utf-8 -*-
require 'yaml'
drupal_settings = YAML.load_file('config/drupal.yml')

def save_comment_with_children(comment, commentable, parent = nil)
  @anonym ||= User.first(:conditions => ['login=?', 'anonym'])

  new_comment = Comment.new
  new_comment.commentable = commentable
  new_comment.parent = parent || commentable.comments.root
  new_comment.text = comment.comment
  new_comment.author = User.first(:conditions => ['drupal_uid = ?', comment.uid]) || @anonym
  new_comment.created_at = Time.at(comment.timestamp)
  new_comment.updated_at = Time.at(comment.timestamp)

  if new_comment.save
    # save children
    comment.children.each do |child|
      save_comment_with_children(child, commentable, new_comment)
    end
  else
    puts "Не удалось сохранить ответ #{comment.cid} для #{commentable.id}"
    puts new_comment.errors.to_a.collect { |e| e.join(": ") }.join("\n")
  end
end

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
    Rake::Task["drupal:get_db"].execute
    Rake::Task["drupal:apply_db"].execute
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

  desc "Run full import from drupal (reset db, remove local files, get files, db, import all from db)."
  task :import => :environment do
    puts "\n\t\t=== Удаляем имеющиеся файлы материалов из public/system/ === \n"
    system "rm -rf public/system"

    puts "\n\t\t=== Сбрасываем текущую базу данных и загружаем в неё данные из seeds.rb === \n"
    puts "Удаляем базу данных"
    Rake::Task["db:drop"].execute
    puts "Создаём базу данных"
    Rake::Task["db:create"].execute
    puts "Создаём структуру бд из schema.rb"
    Rake::Task["db:schema:load"].execute
    puts "Загружаем данные в базу из seeds.rb"
    Rake::Task["db:seed"].execute

    puts "\n\t\t=== Получаем файлы со старого сайта === \n"
    Rake::Task["drupal:get_files"].execute

    puts "\n\t\t=== Получаем базу данных старого сайта === \n"
    Rake::Task["drupal:get_db"].execute

    puts "\n\t\t=== Разворачиваем базу данных === \n"
    Rake::Task["drupal:apply_db"].execute

    puts "\n\t\t=== Импортируем данные из старой базы данных === \n"
    Rake::Task["drupal:import:database"].execute
  end

  namespace :import do
    desc "Import content from local drupal database"
    task :database => :environment do
      puts "\n\t=== Импортируются пользователи === \n"
      Rake::Task["drupal:import:users"].execute
      puts "\n\t=== Импортируются предметы === \n"
      Rake::Task["drupal:import:disciplines"].execute
      puts "\n\t=== Импортируются факультеты и кафедры === \n"
      Rake::Task["drupal:import:faculties_and_departments"].execute
      puts "\n\t=== Импортируются новости === \n"
      Rake::Task["drupal:import:news"].execute
      puts "\n\t=== Импортируются преподаватели === \n"
      Rake::Task["drupal:import:teachers"].execute
      puts "\n\t=== Импортируется форум === \n"
      Rake::Task["drupal:import:forum"].execute
      puts "\n\t=== Импортируется контент === \n"
      Rake::Task["drupal:import:content"].execute
    end

    desc "Import users from drupal database"
    task :users => :environment do
      require 'php_serialize'
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

      class DrupalUrlAlias < DrupalConnect
        set_table_name "url_alias"
      end

      users = DrupalUser.all(:include => :drupal_profile_values)
      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      users_counter = 0
      error_users_counter = 0
      users.each do |drupal_user|
        if drupal_user.uid != 0
          details = drupal_user.drupal_profile_values

          user = User.new
          user.login = drupal_user.name
          user.email = drupal_user.mail
          user.password = 'will_overwritten_below'
          user.password_confirmation = 'will_overwritten_below'
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

          if user.save
            users_counter += 1
            User.record_timestamps = false
            user.update_attributes({:crypted_password => drupal_user.pass, :password_salt => ''})
            User.record_timestamps = true

            system_drupal_path = "user/#{drupal_user.uid}"
            RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => user, :subdomain => 'bsuir')
            DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
              RedirectionRule.create(:old_path => "/#{a.dst}" , :object => user, :subdomain => 'bsuir')
            end
          else
            error_users_counter += 1
            puts "Ошибка с #{drupal_user.uid} #{drupal_user.name}"
            puts user.errors.to_a.collect { |e| e.join(": ") }.join("\n")
          end
        end# if drupal_user.uid != 0 ...
      end# users.each do |drupal_user|
      puts "\tБыло проимпортированно #{users_counter}. С ошибками: #{error_users_counter}"
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

      class DrupalUrlAlias < DrupalConnect
        set_table_name "url_alias"
      end

      disciplines = DrupalTermData.all(:conditions => {:vid => 2})
      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      disciplines_counter = 0
      error_disciplines_counter = 0
      disciplines.each do |drupal_discipline|
        discipline = Discipline.new
        drupal_discipline.description.strip!

        if drupal_discipline.description.blank?
          discipline.name = drupal_discipline.name
        else
          discipline.name = drupal_discipline.description
        end
        if drupal_discipline.description.present? && drupal_discipline.name != drupal_discipline.description
          discipline.abbr = drupal_discipline.name
        end
        discipline.college = @bsuir
        discipline.drupal_tid = drupal_discipline.tid

        if discipline.save
          disciplines_counter += 1

          system_drupal_path = "taxonomy/term/#{drupal_discipline.tid}"
          RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => discipline, :subdomain => 'bsuir')
          DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
            RedirectionRule.create(:old_path => "/#{a.dst}" , :object => discipline, :subdomain => 'bsuir')
          end

        else
          error_disciplines_counter += 1
          puts "Ошибка с #{drupal_discipline.tid} #{drupal_discipline.name}"
          puts discipline.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end
      end# disciplines.each do |drupal_discipline|
      puts "\tБыло проимпортированно #{disciplines_counter}. С ошибками: #{error_disciplines_counter}"
    end# drupal:import:disciplines

    desc "Import faculties and departments from drupal database"
    task :faculties_and_departments => :environment do
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
        has_many :drupal_term_nodes, :foreign_key => :tid, :primary_key => :tid
      end

      class DrupalNodeRevision < DrupalConnect
        set_table_name "node_revisions"
        has_one :drupal_term_node, :foreign_key => :vid, :primary_key => :vid
      end

      class DrupalTermNode < DrupalConnect
        set_table_name "term_node"
        belongs_to :drupal_term_data, :foreign_key => :tid, :primary_key => :tid
        belongs_to :drupal_node_revision, :foreign_key => :vid, :primary_key => :vid
      end

      faculties = DrupalTermData.all(:conditions => {:vid => 9})
      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      counter = 0
      error_counter = 0
      department_counter = 0
      error_department_counter = 0

      faculties.each do |drupal_faculty|
        faculty = Faculty.new

        faculty.name = drupal_faculty.description
        faculty.abbr = drupal_faculty.name
        faculty.college = @bsuir

        if faculty.save
          counter += 1
          # add departments
          drupal_faculty.drupal_term_nodes.each do |drupal_department|
            node = drupal_department.drupal_node_revision
            department = faculty.departments.new
            department.name = node.title
            department.created_at = Time.at(node.timestamp)
            department.drupal_nid = node.nid

            if department.save
              department_counter += 1
            else
              error_department_counter += 1
              puts "Ошибка с nid: #{node.nid} #{node.title}"
              puts department.errors.to_a.collect { |e| e.join(": ") }.join("\n")
            end
          end
        else
          error_counter += 1
          puts "Ошибка с # #{drupal_faculty.tid} #{drupal_faculty.name}"
          puts faculty.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end# if faculty.save
      end# faculties.each do |drupal_faculty|

      puts "\tФакультеты. Проимпортированно: #{counter}. С ошибками: #{error_counter}"
      puts "\tКафедры. Проимпортированно: #{department_counter}. С ошибками: #{error_department_counter}"
    end# drupal:import:faculties_and_departments

    desc "Import news from drupal database"
    task :news => :environment do
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

      class DrupalNode < DrupalConnect
        set_table_name "node"
        set_primary_key "nid"
        has_one :counter, :foreign_key => :nid, :class_name => 'DrupalNodeCount'
        has_many :drupal_node_revisions, :foreign_key => :nid
        has_many :comments, :class_name => 'DrupalComment', :foreign_key => :nid
      end

      class DrupalNodeRevision < DrupalConnect
        set_table_name "node_revisions"
        belongs_to :drupal_node
      end

      class DrupalNodeCount < DrupalConnect
        set_table_name "node_counter"
      end

      class DrupalComment < DrupalConnect
        set_table_name "comments"
        set_primary_key "cid"
        belongs_to :drupal_node
        has_many :children, :class_name => 'DrupalComment', :foreign_key => :pid
      end

      class DrupalUrlAlias < DrupalConnect
        set_table_name "url_alias"
      end

      DrupalNode.inheritance_column = nil
      newsitems = DrupalNode.all(:conditions => {:type => 'news'})

      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      counter = 0
      error_counter = 0

      newsitems.each do |drupal_newsitem|
        drupal_revision = drupal_newsitem.drupal_node_revisions.first(:conditions => ['node_revisions.vid = ?', drupal_newsitem.vid])

        newsitem = Newsitem.new

        newsitem.title = drupal_revision.title
        newsitem.body = drupal_revision.body
        newsitem.teaser = drupal_revision.teaser
        newsitem.published = drupal_newsitem.status
        newsitem.commented = (drupal_newsitem.comment > 0)
        newsitem.created_at = Time.at(drupal_newsitem.created)
        newsitem.updated_at = Time.at(drupal_newsitem.changed)
        newsitem.author = User.first(:conditions => ['drupal_uid = ?', drupal_newsitem.uid])

        newsitem.colleges << @bsuir

        if newsitem.save
          counter += 1
          # views counter
          newsitem.reload
          VisitsCounter.record_timestamps = false
          newsitem.visits_counter.update_attributes({:count => drupal_newsitem.counter.totalcount,
                                                   :updated_at => Time.at(drupal_newsitem.counter.timestamp)})
          VisitsCounter.record_timestamps = true

          system_drupal_path = "node/#{drupal_newsitem.nid}"
          RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => newsitem, :subdomain => 'bsuir')
          DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
            RedirectionRule.create(:old_path => "/#{a.dst}" , :object => newsitem, :subdomain => 'bsuir')
          end

          # comments
          comments = drupal_newsitem.comments.all(:order => 'timestamp', :conditions => {:pid => 0})
          if comments
            comments.each do |comment|
              save_comment_with_children(comment, newsitem)
            end
          end
        else
          error_counter += 1
          puts "Ошибка с # #{drupal_newsitem.nid} #{drupal_newsitem.title}"
          puts newsitem.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end# if newsitem.save
      end# newsitems.each do |drupal_newsitem|
      puts "\tНовости. Проимпортированно: #{counter}. С ошибками: #{error_counter}"
    end# drupal:import:news

    desc "Import teachers from drupal database"
    task :teachers => :environment do
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

      class DrupalNode < DrupalConnect
        set_table_name "node"
        set_primary_key "nid"
        has_many :drupal_node_revisions, :foreign_key => :nid
        has_one :counter, :foreign_key => :nid, :class_name => 'DrupalNodeCount'
        has_many :comments, :class_name => 'DrupalComment', :foreign_key => :nid
      end

      class DrupalNodeRevision < DrupalConnect
        set_table_name "node_revisions"
        set_primary_key "vid"
        belongs_to :drupal_node, :foreign_key => :nid
        has_one :drupal_content_type_lecturer, :foreign_key => :vid
        has_one :drupal_content_field_name, :foreign_key => :vid
        has_many :drupal_content_field_photos, :foreign_key => :vid
        has_many :drupal_photos, :through => :drupal_content_field_photos, :source => :drupal_file, :foreign_key => :vid
        has_many :drupal_content_field_disciplines, :foreign_key => :vid
      end

      class DrupalContentTypeLecturer < DrupalConnect
        set_table_name "content_type_lecturer"
        belongs_to :drupal_node_revision
      end

      class DrupalContentFieldName < DrupalConnect
        set_table_name "content_field_name"
        belongs_to :drupal_node_revision
      end

      class DrupalContentFieldPhoto < DrupalConnect
        set_table_name "content_field_photos"
        set_primary_key "field_photos_fid"
        belongs_to :drupal_node_revision
        has_one :drupal_file, :foreign_key => :fid, :primary_key => :field_photos_fid
      end

      class DrupalFile < DrupalConnect
        set_table_name "files"
        set_primary_key "fid"
        belongs_to :drupal_content_field_photo
      end

      class DrupalContentFieldDiscipline < DrupalConnect
        set_table_name "content_field_disciplines"
        belongs_to :drupal_node_revision
      end

      class DrupalNodeCount < DrupalConnect
        set_table_name "node_counter"
      end

      class DrupalComment < DrupalConnect
        set_table_name "comments"
        set_primary_key "cid"
        belongs_to :drupal_node
        has_many :children, :class_name => 'DrupalComment', :foreign_key => :pid
      end

      class DrupalUrlAlias < DrupalConnect
        set_table_name "url_alias"
      end

      DrupalNode.inheritance_column = nil
      teachers = DrupalNode.all(:conditions => {:type => 'lecturer'})

      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})
      counter = 0
      error_counter = 0

      teachers.each do |drupal_teacher|
        drupal_revision = drupal_teacher.drupal_node_revisions.first(:conditions => ['node_revisions.vid = ?', drupal_teacher.vid])

        drupal_fields = drupal_revision.drupal_content_type_lecturer

        teacher = Teacher.new
        teacher.first_name = drupal_revision.drupal_content_field_name.field_name_value
        teacher.middle_name = drupal_fields.field_patronymic_value
        teacher.last_name = drupal_fields.field_lastname_value
        teacher.email = drupal_fields.field_email_email
        teacher.post = drupal_fields.field_zvanie_value
        teacher.text = drupal_revision.body
        teacher.created_at = Time.at(drupal_teacher.created)
        teacher.updated_at = Time.at(drupal_teacher.changed)
        teacher.author = User.first(:conditions => ['drupal_uid = ?', drupal_teacher.uid])
        teacher.drupal_nid = drupal_teacher.nid

        if teacher.save
          counter += 1
          # photos
          drupal_revision.drupal_photos.each do |d_photo|
            file = d_photo.filepath.sub(/sites\/default\/files/, 'tmp/drupal_files')

            if File.exist?(file)
              photo = teacher.teacher_photos.new(:picture => File.open(file))
              unless photo.save
                puts "Не удалось сохранить фотографию у nid #{drupal_teacher.nid}"
                puts photo.errors.to_a.collect { |e| e.join(": ") }.join("\n")
              end
            end
          end

          # job
          job = teacher.teacher_jobs.new
          job.college = @bsuir
          job.department = Department.first(:conditions => ['drupal_nid = ?', drupal_fields.field_kafedra_nid])
          job.created_at = Time.at(drupal_teacher.created)
          job.updated_at = Time.at(drupal_teacher.created)

          if job.save
            # disciplines
            drupal_revision.drupal_content_field_disciplines.each do |d_discipline|
              subject = job.teacher_subjects.new
              subject.discipline = Discipline.first(:conditions => ['college_id = ? AND drupal_tid= ?', @bsuir.id, d_discipline.field_disciplines_value])
              unless subject.save
                puts "Не удалось сохранить связь с предметом у nid #{drupal_teacher.nid}"
                puts subject.errors.to_a.collect { |e| e.join(": ") }.join("\n")
              end

            end
          else
            puts "Не удалось сохранить работу у nid #{drupal_teacher.nid}"
            puts job.errors.to_a.collect { |e| e.join(": ") }.join("\n")
          end

          # views counter
          teacher.reload
          VisitsCounter.record_timestamps = false
          teacher.visits_counter.update_attributes({:count => drupal_teacher.counter.totalcount,
                                                     :updated_at => Time.at(drupal_teacher.counter.timestamp)})
          VisitsCounter.record_timestamps = true

          # collect redirection rules
          system_drupal_path = "node/#{drupal_teacher.nid}"
          RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => teacher, :subdomain => 'bsuir')
          DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
            RedirectionRule.create(:old_path => "/#{a.dst}" , :object => teacher, :subdomain => 'bsuir')
          end

          # comments
          comments = drupal_teacher.comments.all(:order => 'timestamp', :conditions => {:pid => 0})
          if comments
            comments.each do |comment|
              save_comment_with_children(comment, teacher)
            end
          end
        else
          error_counter += 1
          puts "Ошибка с # #{drupal_teacher.nid} #{drupal_teacher.title}"
          puts teacher.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end# if teacher.save
      end# teachers.each do |drupal_teacher|
      puts "\tПреподаватели. Проимпортированно: #{counter}. С ошибками: #{error_counter}"
    end# drupal:import:teachers

    desc "Import forum from drupal database"
    task :forum => :environment do
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
        set_primary_key "tid"
        has_many :drupal_term_nodes, :foreign_key => :tid
      end

      # for simple and fast development this class will be used only as reference
      class DrupalTermHierarchy < DrupalConnect
        set_table_name "term_hierarchy"
      end

      class DrupalNode < DrupalConnect
        set_table_name "node"
        set_primary_key "nid"
        has_many :drupal_node_revisions, :foreign_key => :nid
        has_many :drupal_comments, :foreign_key => :nid
        has_one :counter, :foreign_key => :nid, :class_name => 'DrupalNodeCount'
      end

      class DrupalNodeRevision < DrupalConnect
        set_table_name "node_revisions"
        set_primary_key "vid"
        belongs_to :drupal_node, :foreign_key => :nid
        has_one :drupal_term_node, :foreign_key => :vid
      end

      class DrupalTermNode < DrupalConnect
        set_table_name "term_node"
        belongs_to :drupal_term_data, :foreign_key => :tid, :primary_key => :tid
        belongs_to :drupal_node_revision, :foreign_key => :vid, :primary_key => :vid
      end

      class DrupalNodeCount < DrupalConnect
        set_table_name "node_counter"
      end

      class DrupalComment < DrupalConnect
        set_table_name "comments"
      end

      class DrupalUrlAlias < DrupalConnect
        set_table_name "url_alias"
      end

      DrupalNode.inheritance_column = nil

      # destroy all forums
      Forum.root.descendants.each(&:destroy)

      anonym = User.first(:conditions => ['login=?', 'anonym'])
      all_forums_ids = DrupalTermData.all(:conditions => 'vid=8').collect(&:tid)
      first_level_ids = DrupalTermHierarchy.all(:conditions => "tid IN (#{all_forums_ids.join(',')}) AND parent = 0").collect(&:tid)

      first_level = DrupalTermData.all(:conditions => "tid IN (#{first_level_ids.join(',')})")

      first_level.each do |forum_1|
        # create 1st level forum
        new_forum = Forum.root.children.new
        new_forum.title = forum_1.name
        new_forum.description = forum_1.description
        if new_forum.save
          # rules for redirects
          system_drupal_path = "taxonomy/term/#{forum_1.tid}"
          RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => new_forum, :subdomain => 'forum')
          RedirectionRule.create(:old_path => "/forum/#{forum_1.tid}", :object => new_forum, :subdomain => 'forum')
          DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
            RedirectionRule.create(:old_path => "/#{a.dst}" , :object => new_forum, :subdomain => 'forum')
          end

          # get all children
          children_ids = DrupalTermHierarchy.all(:conditions => ['parent = ?', forum_1.tid]).collect(&:tid)
          children = DrupalTermData.all(:conditions => "tid IN (#{children_ids.join(',')})")

          children.each do |drupal_child|
            # create children
            new_child = new_forum.children.new
            new_child.title = drupal_child.name
            new_child.description = drupal_child.description

            if new_child.save
              # rules for redirects
              system_drupal_path = "taxonomy/term/#{drupal_child.tid}"
              RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => new_child, :subdomain => 'forum')
              RedirectionRule.create(:old_path => "/forum/#{drupal_child.tid}", :object => new_child, :subdomain => 'forum')
              DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
                RedirectionRule.create(:old_path => "/#{a.dst}" , :object => new_child, :subdomain => 'forum')
              end

              # fill content
              drupal_child.drupal_term_nodes.each do |term_node|
                revision = term_node.drupal_node_revision
                node = revision.drupal_node

                topic = new_child.topics.new
                topic.subject = node.title
                topic.author = User.first(:conditions => ['drupal_uid = ?', node.uid]) || anonym
                topic.locked = (node.comment != 2)
                topic.sticky = node.sticky
                topic.created_at = Time.at(node.created)
                topic.updated_at = Time.at(node.changed)
                if topic.save
                  # rules for redirects
                  system_drupal_path = "node/#{node.nid}"
                  RedirectionRule.create(:old_path => "/#{system_drupal_path}", :object => topic, :subdomain => 'forum')
                  DrupalUrlAlias.all(:conditions => ['src = ?', system_drupal_path]).each do |a|
                    RedirectionRule.create(:old_path => "/#{a.dst}" , :object => topic, :subdomain => 'forum')
                  end
                else
                  puts "Не удалось сохранить топик форум nid #{node.nid}"
                  puts topic.errors.to_a.collect { |e| e.join(": ") }.join("\n")
                end

                # views counter
                topic.reload
                VisitsCounter.record_timestamps = false
                topic.visits_counter.update_attributes({:count => node.counter.totalcount,
                                                       :updated_at => Time.at(node.counter.timestamp)})
                VisitsCounter.record_timestamps = true

                # first post
                post = topic.posts.new
                post.text = revision.body
                post.author = User.first(:conditions => ['drupal_uid = ?', revision.uid]) || anonym
                post.created_at = Time.at(revision.timestamp)
                post.updated_at = Time.at(revision.timestamp)
                unless post.save
                  puts "Не удалось сохранить первый пост у топика с nid #{node.nid}"
                  puts post.errors.to_a.collect { |e| e.join(": ") }.join("\n")
                end

                # reply
                replies = node.drupal_comments.all(:order => 'timestamp')
                if replies.any?
                  replies.each do |reply|
                    post = topic.posts.new
                    post.text =  reply.comment
                    post.author = User.first(:conditions => ['drupal_uid = ?', reply.uid]) || anonym
                    post.created_at = Time.at(reply.timestamp)
                    post.updated_at = Time.at(reply.timestamp)
                    unless post.save
                      puts "Не удалось сохранить ответ #{reply.cid} в топике с nid #{node.nid}"
                      puts post.errors.to_a.collect { |e| e.join(": ") }.join("\n")
                    end
                  end
                end
              end
            else
              puts "Не удалось сохранить дочерний форум tid #{drupal_child.tid}"
              puts new_child.errors.to_a.collect { |e| e.join(": ") }.join("\n")
            end
          end# children.each do |child|
        else
          puts "Не удалось сохранить форум tid #{forum_1.tid}"
          puts new_forum.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end
      end# first_level.each do |forum_1|
    end# drupal:import:forum

    desc "Import content from drupal database"
    task :content => :environment do
      require 'php_serialize'

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

      class DrupalNode < DrupalConnect
        set_table_name "node"
        set_primary_key "nid"
        default_scope(:joins => "LEFT JOIN `content_field_missing_file` ON content_field_missing_file.vid = node.vid",
                      :conditions => ['content_field_missing_file.field_missing_file_value IS NULL OR  content_field_missing_file.field_missing_file_value <> ?', 'да'])

        has_one :revision, :class_name => 'DrupalNodeRevision', :primary_key => :vid, :foreign_key => :vid
        has_one :counter, :foreign_key => :nid, :class_name => 'DrupalNodeCount'
        has_many :comments, :class_name => 'DrupalComment', :foreign_key => :nid
      end

      class DrupalNodeRevision < DrupalConnect
        set_table_name "node_revisions"
        set_primary_key "vid"
        belongs_to :drupal_node, :foreign_key => :nid
        has_one :drupal_content_field_predmet, :foreign_key => :vid
        has_one :discipline, :through => :drupal_content_field_predmet

        has_many :reshenies, :class_name => 'DrupalContentFieldReshenieFile', :foreign_key => :vid
        has_many :zadanies, :class_name => 'DrupalContentFieldZadanieFile', :foreign_key => :vid
        has_many :konspekts, :class_name => 'DrupalContentFieldKonspekt', :foreign_key => :vid
        has_many :uploads, :class_name => 'Upload', :foreign_key => :vid
      end

      class DrupalNodeCount < DrupalConnect
        set_table_name "node_counter"
      end

      class DrupalComment < DrupalConnect
        set_table_name "comments"
        set_primary_key "cid"
        belongs_to :drupal_node
        has_many :children, :class_name => 'DrupalComment', :foreign_key => :pid
      end

      class DrupalContentFieldPredmet < DrupalConnect
        set_table_name "content_field_predmet"
        belongs_to :drupal_node_revision
        belongs_to :discipline, :class_name => 'DrupalDiscipline', :foreign_key => 'field_predmet_value', :primary_key => 'tid'
      end

      class DrupalDiscipline < DrupalConnect
        set_table_name "term_data"
        set_primary_key "tid"
        default_scope :conditions => {:vid => 2}
      end

      class DrupalContentFieldReshenieFile < DrupalConnect
        set_table_name "content_field_reshenie_file"
        set_primary_key 'field_reshenie_file_fid'
        default_scope :conditions => 'field_reshenie_file_fid IS NOT NULL'
        has_one :file, :class_name => 'DrupalFile', :foreign_key => :fid
        def description
          descr = PHP.unserialize(field_reshenie_file_data)['description']
          (descr.present?) ? descr : nil
        end
      end

      class DrupalContentFieldZadanieFile < DrupalConnect
        set_table_name "content_field_zadanie_file"
        set_primary_key 'field_zadanie_file_fid'
        default_scope :conditions => 'field_zadanie_file_fid IS NOT NULL'
        has_one :file, :class_name => 'DrupalFile', :foreign_key => :fid
        def description
          descr = PHP.unserialize(field_zadanie_file_data)['description']
          (descr.present?) ? descr : nil
        end
      end

      class DrupalContentFieldKonspekt < DrupalConnect
        set_table_name "content_field_konspekt"
        set_primary_key 'field_konspekt_fid'
        default_scope :conditions => 'field_konspekt_fid IS NOT NULL'
        has_one :file, :class_name => 'DrupalFile', :foreign_key => :fid
        def description
          descr = PHP.unserialize(field_konspekt_data)['description']
          (descr.present?) ? descr : nil
        end
      end

      class DrupalUpload < DrupalConnect
        set_table_name "upload"
        set_primary_key 'fid'
        has_one :file, :class_name => 'DrupalFile', :foreign_key => :fid
      end


      class DrupalFile < DrupalConnect
        set_table_name "files"
        set_primary_key "fid"
      end


      def present_and_not_empty(value)
        value.present? && !['<p>&nbsp;</p>', '<P> </P>', '<P><BR> </P>', '<P> </P>'].include?(value)
      end

      def get_details(node, params = {}, options = {})
        selects = []
        joins = []
        where = "WHERE node_revisions.vid = #{node.revision.vid}"

        params.each do |param|
          selects << "content_field_#{param[0].to_s}.field_#{param[0].to_s}_value as #{param[1]}"
          joins << "INNER JOIN `content_field_#{param[0].to_s}` ON node_revisions.vid = content_field_#{param[0].to_s}.vid"
        end
        selects << options[:select] if options[:select]
        joins << options[:join] if options[:join]
        DrupalNode.find_by_sql("SELECT #{selects.join(', ')} FROM node_revisions #{joins.join(' ')} #{where}").first
      end

      def correct_semester(value = nil)
        @possible_semesters ||= {
          '1ый семестр' => :semester_1, '2ой семестр' => :semester_2, '3ий семестр' => :semester_3,
          '4ый семестр' => :semester_4, '5ый семестр' => :semester_5, '6ой семестр' => :semester_6
        }
        @possible_semesters[value]
      end

      def content_data(node)
        case node.type
        when "konspekt"
          data = Synopsis.new
          details = get_details(node,
                                {:name => 'name', :prepod => 'prepod', :sem => 'sem', :text => 'primechanie'},
                                {:select => 'content_type_konspekt.field_year_value AS year', :join => 'INNER JOIN content_type_konspekt ON node_revisions.vid = content_type_konspekt.vid'})
          if details
            data.name = details['name']
            data.teacher = details['prepod']
            data.semester = correct_semester(details['sem'])
            data.year = details['year']
            data.description = details['primechanie'] if present_and_not_empty(details['primechanie'])
          end
        when "laby"
          data = Lab.new
          details = get_details(node,
                                { :name => 'theme',
                                  :variant => 'variant', :reshenie_text => 'reshenie'},
                                { :select => 'content_type_laby.field_nomer_value AS number, content_type_laby.field_zadanie_text_value AS zadanie',
                                  :join => 'INNER JOIN content_type_laby ON node_revisions.vid = content_type_laby.vid'})
          if details
            data.theme = details['theme']
            data.number = details['number']
            data.variant =  details['variant']
            data.description = ''.tap do |d|
              if present_and_not_empty(details['zadanie'])
                d << "<h3>Задание</h3>" if present_and_not_empty(details['reshenie'])
                d << details['zadanie']
              end
              if present_and_not_empty(details['reshenie'])
                d << "<h3>Решение</h3>" if d.present?
                d << details['reshenie']
              end
            end
          end
        when "metody"
          details = get_details(node,
                                { :name => 'name', :primechanie => 'primechanie', :prim => 'content' },
                                { :select => 'ctm.field_publish_year_value AS year, ctm.field_type_value AS type, ctm.field_izdatelstvo_value AS publisher, ctm.field_avtor_value AS authors',
                                  :join => 'INNER JOIN content_type_metody AS ctm ON node_revisions.vid = ctm.vid'})
          if details
            case details['type']
            when 'Методическое пособие', 'Лабораторный практикум', 'Книга'
              data = case details['type']
                     when 'Методическое пособие' then Manual.new
                     when 'Лабораторный практикум' then LaboratoryPractical.new
                     when 'Книга' then Book.new
                     end
              data.name = details['name']
              data.authors = details['authors']
              data.publishing_company = details['publisher']
              data.year = details['year']
              data.content = details['content']
              data.description = details['description']
            when 'План', 'Другое'
              data = Other.new
              data.title = node.title
              data.description = ''.tap do |b|
                b << details['content'] if present_and_not_empty(details['content'])
                if present_and_not_empty(details['primechanie'])
                  b << "<hr />" if b.present?
                  b << details['primechanie']
                end
              end
            end
          end
        when "other"
          data = Other.new
          data.title = node.title
          details = get_details(node, :primechanie => 'primechanie')
          if details
            data.description = ''.tap do |b|
              if present_and_not_empty(details['primechanie'])
                b << "<hr />"
                b << details['primechanie']
              end
            end
          end
        when "shpory"
          data = Crib.new
          details = get_details(node,
                                { :name => 'name', :prim => 'primechanie', :prepod => 'prepod', :sem => 'sem', :text => 'list_of_questions' },
                                { :select => 'content_type_shpory.field_questions_count_value AS number_of_questions, content_type_shpory.field_done_questions_value AS number_of_questions_with_answers',
                                  :join => 'INNER JOIN content_type_shpory ON node_revisions.vid = content_type_shpory.vid'})
          if details
            data.name = details['name']
            data.teacher = details['prepod']
            data.semester = correct_semester(details['sem'])
            data.number_of_questions = details['number_of_questions']
            data.number_of_questions_with_answers = details['number_of_questions_with_answers']
            data.questions = details['list_of_questions'] if present_and_not_empty(details['list_of_questions'])
            data.description = details['primechanie'] if present_and_not_empty(details['primechanie'])
          end
        when "tr"
          data = TypicalCalculation.new
          data.theme = node.title
          data.variant = ''
          data.description = node.revision.body if present_and_not_empty(node.revision.body)
          details = get_details(node, :variant => 'variant')
          data.variant = details['variant'] if details
        when "voprosy"
          data = Other.new
          data.title = node.title
          details = get_details(node, :prim => 'primechanie', :text => 'list_of_questions')
          if details
            data.description = ''.tap do |b|
              b << details['list_of_questions'] if present_and_not_empty(details['list_of_questions'])
              if present_and_not_empty(details['primechanie'])
                b << "<hr />"
                b << details['primechanie']
              end
            end
          end
        end# case
        data.created_at = Time.at(node.created)
        data.updated_at = Time.at(node.changed)
        data
      end

      @bsuir = College.first(:conditions => {:subdomain => 'bsuir'})

      DrupalNode.inheritance_column = nil
      drupal_contents = DrupalNode.all(:conditions => ["type IN ('voprosy', 'other', 'konspekt', 'tr', 'laby', 'shpory', 'metody')"], :include => :revision)

      Material.record_timestamps = false
      drupal_contents.each do |node|
        material = Material.new
        material.created_by = User.first(:conditions => ['drupal_uid = ?', node.uid])
        material.discipline = Discipline.first(:conditions => {:drupal_tid => node.revision.discipline.tid})
        material.commented = (node.comment > 0)
        material.published = node.status
        material.created_at = Time.at(node.created)

        material.data = content_data(node)

        # add files
        files = []

        if ['voprosy', 'konspekt', 'metody', 'other']
          files += node.revision.konspekts.collect { |k| [k.file.filepath, k.description] }
        elsif ['laby', 'shpory']
          files += node.revision.reshenies.collect { |k| [k.file.filepath, k.description] }
        elsif ['laby']
          files += node.revision.zadanies.collect { |k| [k.file.filepath, k.description] }
        elsif ['tr', 'metody']
          files += node.revision.uploads.collect { |k| [k.file.filepath, k.description] }
        end

        files.each do |file|
          filepath = file[0].sub(/sites\/default\/files/, 'tmp/drupal_files')
          description = nil
          if File.exist?(filepath)
            material.attaches.build(:file => File.open(filepath), :description => file[1])
          end
        end

        if material.save
          material.title # to prevent updating updated_at when title will be firstly requested
          material.update_attribute(:updated_at, Time.at(node.changed))

          # views counter
          material.reload
          VisitsCounter.record_timestamps = false
          material.visits_counter.update_attributes({:count => node.counter.totalcount,
                                                   :updated_at => Time.at(node.counter.timestamp)})
          VisitsCounter.record_timestamps = true

          # comments
          comments = node.comments.all(:order => 'timestamp', :conditions => {:pid => 0})
          if comments
            comments.each do |comment|
              save_comment_with_children(comment, material)
            end
          end
        else
          puts "Не удалось сохранить материал с nid #{node.nid} (#{node.title})"
          puts material.errors.to_a.collect { |e| e.join(": ") }.join("\n")
        end# if material.save!
      end
      Material.record_timestamps = true
    end# drupal:import:content
  end# drupal:import
end# drupal
