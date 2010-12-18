class Attach < ActiveRecord::Base
  belongs_to :container, :polymorphic => true

  has_attached_file :file

  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 100.megabytes

  def name
    return description if description.present?
    file_file_name
  end
end
