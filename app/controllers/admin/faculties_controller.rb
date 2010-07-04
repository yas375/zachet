class Admin::FacultiesController < Admin::AdminController
  before_filter :set_current_navigation
  before_filter :get_all_faculties, :only => [:new, :create]

  def index
    @faculties = Faculty.all(:conditions => {:college_id => params[:college_id]}, :order => :name, :include => [:college, :departments])
  end

  def new
    @faculty = Faculty.new
  end

  def create
    @faculty = Faculty.new(params[:faculty])
    @faculty.college_id = params[:college_id]
    if @faculty.save
      flash[:notice] = "Факультет добавлен"
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  def edit
    @faculty = Faculty.find(params[:id])
  end

  def update
    @faculty = Faculty.find(params[:id])
    if @faculty.update_attributes(params[:faculty])
      flash[:notice] = "Факультет обновлён"
      redirect_to :action => :index
    else
      render :action => :edit
    end
  end

  def destroy
    @faculty = Faculty.find(params[:id])
    @faculty.destroy
    flash[:notice] = "Факультет удалён"
    redirect_to :action => :index
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}"
  end

  def get_all_faculties
    @faculties = Faculty.all(:conditions => {:college_id => params[:college_id]}, :order => :name)
  end
end
