class Admin::DisciplinesController < Admin::AdminController
  before_filter :set_current_navigation

  def index
    @disciplines = Discipline.all(:conditions => {:college_id => params[:college_id]}, :order => :name)
  end

  def new
    @discipline = Discipline.new
  end

  def create
    @discipline = Discipline.new(params[:discipline])
    @discipline.college_id = params[:college_id]
    if @discipline.save
      flash[:notice] = "Successfully created discipline."
      redirect_to new_admin_college_discipline_path(params[:college_id])
    else
      render :action => 'new'
    end
  end

  def edit
    @discipline = Discipline.find(params[:id])
  end

  def update
    @discipline = Discipline.find(params[:id])
    if @discipline.update_attributes(params[:discipline])
      flash[:notice] = "Successfully updated discipline."
      redirect_to admin_college_disciplines_path(params[:college_id])
    else
      render :action => 'edit'
    end
  end

  def destroy
    @discipline = Discipline.find(params[:id])
    @discipline.destroy
    flash[:notice] = "Successfully destroyed discipline."
    redirect_to admin_college_disciplines_path
  end

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}"
  end
end
