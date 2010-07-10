# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# add admin
User.create!(:email => 'admin@example.com', :login => 'admin', :password => 'admin', :password_confirmation => 'admin')

# add colleges
bsu = College.create!(:subdomain => 'bsu', :abbr => 'БГУ', :name => 'Белорусский Государственный Университет')
bsuir = College.create!(:subdomain => 'bsuir', :abbr => 'БГУИР', :name => 'Белорусский Государственный Университет Информатики и Радиоэлектроники')

# add faculties
fitu = Faculty.create!(:name => 'Факультет Информационных Технологий и Управления', :abbr => 'ФИТиУ', :college => bsuir)
ksis = Faculty.create!(:name => 'Факультет Компьютерных Систем и Сетей', :abbr => 'ФКСиС', :college => bsuir)
journ = Faculty.create!(:name => 'Факультет журналистики', :college => bsu)

# add departments
itas = Department.create!(:name => 'Кафедра информационных технологий автоматизированных систем', :abbr => 'ИТАС', :faculty => fitu)
iit = Department.create!(:name => 'Кафедра интеллектуальных информационных технологий', :abbr => 'ИИТ', :faculty => fitu)
poit = Department.create!(:name => 'Кафедра программного обеспечения информационных технологий', :abbr => 'ПОИТ', :faculty => fitu)

# add disciplines
matem = Discipline.create!(:name => 'Высшая математика', :college => bsuir)
fizika = Discipline.create!(:name => 'Физика', :college => bsuir)
asu = Discipline.create!(:name => 'Автоматизированные Системы Управления', :abbr => 'АСУ',  :college => bsuir)
matem_bsu = Discipline.create!(:name => 'Высшая математика', :college => bsu)

# add teachers
batin = Teacher.create!(:last_name => 'Батин', :first_name => 'Николай', :middle_name => 'Николаевич', :email => 'nvbatin@mail.ru')
prep_1 = Teacher.create!(:last_name => 'Иванов', :middle_name => 'Петрович', :email => 'asd@as.as')

# add teacher job
job_1 = TeacherJob.create!(:teacher => batin, :college => bsuir, :department => itas)
job_2 = TeacherJob.create!(:teacher => prep_1, :college => bsu)
job_3 = TeacherJob.create!(:teacher => prep_1, :college => bsuir, :department => iit)
