class TeacherPhoto < ActiveRecord::Base
  belongs_to :teacher

  has_attached_file :picture, :styles => { :medium => "600x600", :thumb => "100x100#" }

  validates_attachment_presence :picture
  validates_attachment_size :picture, :less_than => 5.megabytes

  # TODO use validator of content type
  # validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/png']
end
