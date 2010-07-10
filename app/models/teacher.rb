class Teacher < ActiveRecord::Base
  validates_presence_of :last_name


  def name
    res = last_name
    unless first_name.blank?
      res << " #{first_name}"
      res << " #{middle_name}" unless middle_name.blank?
    end
    res
  end
end
