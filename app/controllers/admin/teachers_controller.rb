class Admin::TeachersController < Admin::AdminController
  before_filter :set_current_navigation

  def new
     @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      flash[:notice] = "Преподаватель #{@teacher.last_name} успешно добавлен"
      redirect_to :action => :show
    else
      render :action => :new
    end
  end

  def index
    @teachers = Teacher.all(:include => {:teacher_jobs => :college})
  end

  def show
    @teacher = Teacher.find(params[:id], :include => {:teacher_jobs => [:college, {:teacher_subjects => :discipline}]})
  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])

    if @teacher.update_attributes(params[:teacher])
      flash[:notice] = "Преподаватель успешно обновлен"
      redirect_to :action => :show
    else
      render :action => :edit
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy

    redirect_to :action => :index
  end

  private

  def set_current_navigation
    current_navigation :teachers
  end
end
