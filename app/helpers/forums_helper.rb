# -*- coding: utf-8 -*-
module ForumsHelper
  def forum_actions(forum)
    ''.tap do |actions|
      actions << (link_to(image_tag('arrow_up.png'), move_up_forum_path(forum))) if forum.left_sibling
      actions << link_to(image_tag('arrow_down.png'), move_down_forum_path(forum)) if forum.right_sibling
      actions << link_to(image_tag('web-app-theme/application_edit.png'), edit_forum_path(forum))
      actions << link_to(image_tag('web-app-theme/cross.png'), forum, :confirm => 'Точно удалить?', :method => :delete)
    end
  end

  def forum_breadcrumbs(forum, include_self = false)
    crumbs = [link_to('Форумы', root_path)]
    if include_self
      parents = forum.self_and_ancestors.all
    else
      parents = forum.ancestors.all
    end
    parents.shift
    parents.each{|p| crumbs << link_to(p.title, forum_path(p))}
    content_tag :div, crumbs.join(' > '), :class => 'breadcrumbs'
  end
end
