class NewsCell < ::Cell::Base

  def global
    scope = Newsitem.news_on_main.published.global.descend_by_created_at
    if @opts[:without_first]
      scope = scope.without_first
    end
    @news = scope
    render
  end

  # новости ВУЗа или ВУЗов в зависомости от того есть параметр @opts[:college]
  def local
    scope = Newsitem.news_on_main
    if @opts[:college] # если надо получить только новости определённого ВУЗа, то и первую новость в выводе можно сюда не включать т.к. она будет в latest
      scope = scope.without_first.local(@opts[:college])
    else
      scope = scope.local_all
      @all = true
    end
    @news = scope.published.descend_by_created_at
    render
  end

  def latest
    scope = Newsitem
    if @opts[:college] # если указан универ, то получаем последнюю новость из новостей этого универа
      scope = scope.local(@opts[:college])
    else # иначе получаем из последних
      scope = scope.global
    end
    @newsitem = scope.published.descend_by_created_at.first
    render
  end
end
