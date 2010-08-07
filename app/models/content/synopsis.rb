class Content::Synopsis < Content
  set_table_name 'content_synopses'
  belongs_to :teacher, :class_name => 'User'
end
