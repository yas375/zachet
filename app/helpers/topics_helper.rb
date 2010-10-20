# -*- coding: utf-8 -*-
module TopicsHelper
  def topic_actions(topic)
    actions = link_to image_tag('web-app-theme/application_edit.png '), edit_topic_path(topic)
    actions << link_to(image_tag('web-app-theme/cross.png'), topic, :confirm => 'Точно удалить?', :method => :delete)
    actions
  end
end
