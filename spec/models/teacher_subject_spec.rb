require 'spec_helper'

describe TeacherSubject do
  context "validations" do
    context "presence" do
      it { should validate_presence_of(:teacher_job) }
      it { should validate_presence_of(:discipline) }
    end

    it "should require the same college for discipline and teacher_job" do
      bsuir = Factory(:college)
      bsu = Factory(:college)
      discipline_bsu = Factory(:discipline, :college => bsu)
      discipline_bsuir = Factory(:discipline, :college => bsuir)

      teacher = Factory(:teacher)
      work_bsu = Factory(:teacher_job, :teacher => teacher, :college => bsu)

      teacher_subject = TeacherSubject.new(:teacher_job => work_bsu, :discipline => discipline_bsuir)
      teacher_subject.should have(1).error_on(:discipline)

      teacher_subject.discipline = discipline_bsu
      teacher_subject.should be_valid
    end
  end
end
