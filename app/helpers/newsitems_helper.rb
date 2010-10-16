# -*- coding: utf-8 -*-
module NewsitemsHelper
  def latest_newsitem(college = nil)
    scope = Newsitem
    if college
      scope = scope.local(college)
    else
      scope = scope.global
    end
    newsitem = scope.published.descend_by_created_at.first
    res = content_tag(:h1, h(newsitem.title))
    res << newsitem.teaser
    res
  end

  def latest_news(college, without_first = nil)
    scope = Newsitem.news_on_main.published.descend_by_created_at
    if college == nil
      scope = scope.global
    elsif college == :all
      scope = scope.local_all
      all_colleges = true
    else
      scope = scope.local(college)
    end
    scope = scope.without_first if without_first

    news = scope.all(:include => :colleges)
    if college.nil?
      render :partial => 'newsitems/global_news', :locals => {:news => news }
    else
      render :partial => 'newsitems/local_news', :locals => {:news => news, :all_colleges => (college == :all)}
    end
  end
end
