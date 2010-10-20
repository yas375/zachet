# -*- coding: utf-8 -*-
module ForumsHelper
  def forum_actions(forum)
    actions = link_to image_tag('web-app-theme/application_edit.png '), edit_forum_path(forum)
    actions << link_to(image_tag('web-app-theme/cross.png'), forum, :confirm => 'Точно удалить?', :method => :delete)
    actions
  end

  def forum_breadcrumbs(forum)
    crumbs = [link_to('Форумы', root_path)]
    (parents = forum.ancestors.all).shift
    parents.each{|p| crumbs << link_to(p.title, forum_path(p))}
    crumbs.join(' > ')
  end
end
