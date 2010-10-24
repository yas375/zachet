class Forum < ActiveRecord::Base
  attr_accessible :title, :description, :parent_id

  acts_as_nested_set

  has_many :topics, :dependent => :destroy
  has_many :posts, :through => :topics

  belongs_to :last_post, :class_name => 'Post'

  validates_presence_of :title, :parent_id

  def update_last_post!(without = nil)
    last_posts_ids = Array.new
    proximate_post = posts.last(:order => 'posts.created_at', :conditions => ['posts.id <> ?', without.try(:id) || 0])

    last_posts_ids << proximate_post.id if proximate_post
    last_posts_from_childs = Forum.all(:select => 'last_post_id',
                                       :conditions => ['parent_id = ? AND last_post_id <> ?', id, without.try(:id) || 0])
    last_posts_from_childs.each do |f|
      last_posts_ids << f.last_post_id
    end
    if last_posts_ids.any?
      last = Post.last(:order => 'created_at', :conditions => ["id IN(#{last_posts_ids.join(',')})"])
      update_attribute :last_post, last
    end
  end
end
