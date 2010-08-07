class Content::Crib < Content
  set_table_name 'content_cribs'
  belongs_to :teacher, :class_name => 'User'
end
