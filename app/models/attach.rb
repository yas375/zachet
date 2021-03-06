class Attach < ActiveRecord::Base
  acts_as_visitable :full_log => true

  belongs_to :container, :polymorphic => true

  has_attached_file(:file,
                    :url => '/system/files/:id/:basename.:extension',
                    :path => "#{Rails.root}/files/:class/:id/:basename.:extension")


  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 100.megabytes

  def name
    return description if description.present?
    file_file_name
  end
end
