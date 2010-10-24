# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# add admin
admin = User.create!(:email => 'admin@example.com', :login => 'admin', :password => 'admin', :password_confirmation => 'admin', :active => true)

# root forum
forum = Forum.new(:title => 'Верхний уровень')
forum.save(false)

# add colleges
bsuir = College.create!(:subdomain => 'bsuir', :abbr => 'БГУИР', :name => 'Белорусский Государственный Университет Информатики и Радиоэлектроники')
bsu = College.create!(:subdomain => 'bsu', :abbr => 'БГУ', :name => 'Белорусский Государственный Университет')

# add faculties
journ = Faculty.create!(:name => 'Факультет журналистики', :college => bsu)

# add departments
itas = Department.create!(:name => 'Кафедра информационных технологий автоматизированных систем', :abbr => 'ИТАС', :faculty => journ)
iit = Department.create!(:name => 'Кафедра интеллектуальных информационных технологий', :abbr => 'ИИТ', :faculty => journ)
poit = Department.create!(:name => 'Кафедра программного обеспечения информационных технологий', :abbr => 'ПОИТ', :faculty => journ)

# add disciplines
fizika = Discipline.create!(:name => 'Физика', :college => bsu)
asu = Discipline.create!(:name => 'Автоматизированные Системы Управления', :abbr => 'АСУ',  :college => bsu)
matem = Discipline.create!(:name => 'Высшая математика', :college => bsu)

# add teachers
batin = Teacher.create!(:last_name => 'Батин', :first_name => 'Николай', :middle_name => 'Николаевич', :email => 'nvbatin@mail.ru')
prep_1 = Teacher.create!(:last_name => 'Иванов', :middle_name => 'Петрович', :email => 'asd@as.as')

# add teacher job
job_1 = TeacherJob.create!(:teacher => batin, :college => bsu)
job_2 = TeacherJob.create!(:teacher => prep_1, :college => bsu)

# add disciplines for some jobs
teacher_subj_1 = TeacherSubject.create!(:discipline => matem, :teacher_job => job_1)
teacher_subj_2 = TeacherSubject.create!(:discipline => fizika, :teacher_job => job_2)
teacher_subj_5 = TeacherSubject.create!(:discipline => asu, :teacher_job => job_1)
teacher_subj_6 = TeacherSubject.create!(:discipline => matem, :teacher_job => job_2)

# add some content
matem.content_synopses.create!(:title => 'Конспект лекций Цегельника ', :body => 'Отсканированный, аккуратный конспект', :author => admin)
matem.content_synopses.create!(:title => 'Конспект 2009-2010', :body => 'Качество страдает', :year => '2009-2010', :author => admin)
