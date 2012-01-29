namespace :mashpit do
  task :connection do
    unless @mashpit_loaded
      @mashpit_loaded = require 'lib/tasks/mashpit.rb'
    end
  end

  desc "Fill sqlite database from application database"
  task :fill_database => [:environment, 'mashpit:connection'] do
    raise MashpitLecturer.first.subjects.to_yaml
    @bsuir = College.where(:subdomain => 'bsuir').first
    raise "Can't find bsuir" unless @bsuir
    MashpitSubject.destroy_all
    MashpitLecturer.destroy_all

    # Fill disciplines
    @bsuir.disciplines.each do |discipline|
      MashpitSubject.create!(:abbr => discipline.abbr, :name => discipline.name)
    end

    # fill teachers
    @bsuir.teachers.each do |teacher|
      new_teacher = MashpitLecturer.create!(:first_name => teacher.first_name,
                                            :last_name => teacher.last_name,
                                            :middle_name => teacher.middle_name,
                                            :degree => teacher.post,
                                            :email => teacher.email)
      teacher.teacher_subjects.each do |subject|
        mashpit_subject = MashpitSubject.where(:name => subject.name)
        new_teacher.subjects << mashpit_subject if mashpit_subject
      end
    end
  end
end
