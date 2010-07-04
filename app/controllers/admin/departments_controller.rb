class Admin::DepartmentsController < Admin::AdminController
  before_filter :set_current_navigation
  before_filter :get_all_departments, :only => [:new, :create]
  # FIXME validate college_id in actions

  def index
    @departments = Department.all(:conditions => {:faculty_id => params[:faculty_id]}, :order => :name)
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    @department.faculty_id = params[:faculty_id]
    if @department.save
      flash[:notice] = "Кафедра добавлена"
      redirect_to :action => :new
    else
      render :action => :new
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      flash[:notice] = "Кафедра обновлена"
      redirect_to :action =>:index
    else
      render :action => :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    flash[:notice] = "Кафедра удалена"
    redirect_to :action => :index
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}"
  end

  def get_all_departments
    @departments = Department.all(:conditions => {:faculty_id => params[:faculty_id]}, :order => :name)
  end
end
