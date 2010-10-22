# -*- coding: utf-8 -*-
module PostsHelper
  def post_actions(post)
    actions = link_to image_tag('web-app-theme/application_edit.png '), edit_topic_post_path(post.topic, post)
    actions << link_to(image_tag('web-app-theme/cross.png'), topic_post_path(post.topic, post), :confirm => 'Точно удалить?', :method => :delete)
    actions
  end
end
