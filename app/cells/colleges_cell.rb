class CollegesCell < ::Cell::Base

  def list
    @colleges = College.ascend_by_abbr.all
    render
  end

end
