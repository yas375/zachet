class College::NewsitemsController < College::CollegeController
  def index
    @newsitems = current_college.newsitems.all
  end

  def show
    @newsitem = Newsitem.find(params[:id])
    @newsitem.increment_visits
  end
end
