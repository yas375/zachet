# -*- coding: utf-8 -*-
module PostsHelper
  def post_actions(post)
    actions = link_to image_tag('web-app-theme/application_edit.png '), edit_topic_post_path(post.topic, post)
    actions << link_to(image_tag('web-app-theme/cross.png'), topic_post_path(post.topic, post), :confirm => 'Точно удалить?', :method => :delete)
    actions
  end

  def last_post(post = nil)
    a = Array.new
    if post
      a << link_to(h(truncate(post.text, :length => 10)),
                   topic_path(post.topic, :anchor => post.id))
      a << link_to(post.author.name, user_path(post.author))
      a << format_date_and_time(post.created_at)
    end
    a.join('<br />').html_safe
  end
end
