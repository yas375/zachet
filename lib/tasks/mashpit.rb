class MashpitConnect < ActiveRecord::Base
  db = YAML.load_file('config/mashpit.yml')
  establish_connection(:adapter  => "sqlite3",
                       :database => db['database']['database'])
end

class MashpitSubject < MashpitConnect
  set_table_name "subjects"
  has_many :lecturers_subjects, :class_name => 'MashpitLecturersSubject', :dependent => :destroy
  has_many :lecturers, :through => :lecturers_subjects
end

class MashpitLecturer < MashpitConnect
  set_table_name "lecturers"
  has_many :lecturers_subjects, :class_name => 'MashpitLecturersSubject', :dependent => :destroy
  has_many :subjects, :through => :lecturers_subjects
end

class MashpitLecturersSubject < MashpitConnect
  set_table_name "lecturers_subjects"
  belongs_to :subject, :class_name => 'MashpitSubject'
  belongs_to :lecturer, :class_name => 'MashpitLecturer'
end
