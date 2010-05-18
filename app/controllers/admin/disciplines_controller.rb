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
    if @discipline.save
      flash[:notice] = "Successfully created discipline."
      redirect_to @discipline
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
      redirect_to @discipline
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @discipline = Discipline.find(params[:id])
    @discipline.destroy
    flash[:notice] = "Successfully destroyed discipline."
    redirect_to disciplines_url
  end
end
