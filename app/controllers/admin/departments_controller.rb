class Admin::DepartmentsController < Admin::AdminController
  before_filter :set_current_navigation

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    if @department.save
      flash[:notice] = "Кафедра добавлена"
      redirect_to admin_college_faculties_path
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
      redirect_to admin_college_faculties_path
    else
      render :action => :edit
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    flash[:notice] = "Кафедра удалена"
    redirect_to admin_college_faculties_path
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}_faculties"
  end
end
