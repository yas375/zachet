class NewsCell < ::Cell::Base

  def global
    @news = Newsitem.published.global.descend_by_created_at
    render
  end

  def local
    scope = Newsitem
    if @opts[:all]
      scope = scope.local_all
      @all = true
    else
      scope = scope
    end
    @news = scope.published.descend_by_created_at
    render
  end

end
