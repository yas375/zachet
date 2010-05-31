module CollegesHelper
  def current_college_url
    college_url(:college_id => params[:college_id])
  end
end
