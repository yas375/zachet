class Admin::DisciplinesController < Admin::AdminController
  def index
    @disciplines = Discipline.all
  end

  def show
    @discipline = Discipline.find(params[:id])
  end

  def new
    @discipline = Discipline.new
  end

  def create
    @discipline = Discipline.new(params[:discipline])
    @discipline.college_id = params[:college_id]
    if @discipline.save
      flash[:notice] = "Successfully created discipline."
      redirect_to admin_college_discipline_path(params[:college_id], @discipline)
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
      redirect_to admin_college_discipline_path(params[:college_id], @discipline)
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
end
