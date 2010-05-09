module CollegesHelper
  def available_colleges
    College.all.collect{|a| [a.abbr, a.id]}
  end
end
