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
      flash[:notice] = "Предмет добавлен"
      redirect_to :action => :new
    else
      render :action => :new
    end
  end

  def edit
    @discipline = Discipline.find(params[:id])
  end

  def update
    @discipline = Discipline.find(params[:id])
    if @discipline.update_attributes(params[:discipline])
      flash[:notice] = "Предмет обновлён"
      redirect_to :index
    else
      render :action => :edit
    end
  end

  def destroy
    @discipline = Discipline.find(params[:id])
    @discipline.destroy
    flash[:notice] = "Предмет удалён"
    redirect_to :action => :index
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}"
  end
end
