class TeacherSubject < ActiveRecord::Base
  belongs_to :discipline
  belongs_to :teacher_job

  validates_presence_of :teacher_job, :discipline
  # TODO написать валидотор, который будет при сохранении проверять, что предмет точно принадлежит тому же ВУЗу, который указан в teacher_job
  validate :discipline_and_teacher_job_should_have_the_same_college

  def discipline_and_teacher_job_should_have_the_same_college
    if discipline && teacher_job
      errors.add(:discipline, 'Такого предмета нету в этом ВУЗе') if discipline.college != teacher_job.college
    end
  end
end
