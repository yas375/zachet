# -*- coding: utf-8 -*-
class Admin::TeachersController < Admin::AdminController
  before_filter :set_current_navigation

  def new
     @teacher = Teacher.new
     1.times { @teacher.teacher_photos.build }
     1.times { @teacher.teacher_jobs.build }
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    @teacher.author = current_user

    if @teacher.save
      flash[:notice] = "Преподаватель #{@teacher.last_name} успешно добавлен"
      redirect_to :action => :index
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
    params[:teacher][:teacher_jobs_attributes].each do |a, job|
      job[:discipline_ids] ||= []
    end

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

  def get_departments
    @college = College.find(params[:college_id])
    @departments = Department.by_college(@college).all
  end

  private

  def set_current_navigation
    current_navigation :teachers
  end
end
