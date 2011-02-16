# -*- coding: utf-8 -*-
class Admin::FacultiesController < Admin::AdminController
  before_filter :find_college, :set_current_navigation
  before_filter :get_all_faculties, :only => [:new, :create]

  def index
    @faculties = Faculty.all(:conditions => {:college_id => @college.id}, :order => :name, :include => [:college, :departments])
  end

  def new
    @faculty = Faculty.new
  end

  def create
    @faculty = Faculty.new(params[:faculty])
    @faculty.college = @college
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

  def import
    if request.post?
      if params[:faculties] && params[:faculties][:file] && params[:faculties][:file].is_a?(Tempfile)
        last_faculty = nil
        @success, @failure = [[], []], [[], []]
        params[:faculties][:file].readlines.each do |line|
          if line[0..1] == '  ' # indent with two spaces - means that it a department
            name, abbr = line.split('*').collect(&:strip)
            d = Department.create(:name => name, :abbr => abbr, :faculty => last_faculty)
            if d.save
              @success[1] << d
            else
              @failure[1] << d
            end
          else # it's faculty
            name, abbr = line.split('*').collect(&:strip)
            last_faculty = Faculty.create(:name => name, :abbr => abbr, :college => @college)
            if last_faculty.save
              @success[0] << last_faculty
            else
              @failure[0] << last_faculty
            end
          end
        end
        flash.now[:notice] = "Добавлено: <b>#{@success[0].count}</b> #{Russian.p(@success[0].count, 'факультет', 'факультета', 'факультетов')}, <b>#{@success[1].count}</b> #{Russian.p(@success[1].count, 'кафедра', 'кафедры', 'кафедр')}" if @success[0].any? || @success[1].any?
        flash.now[:error] = "Неудалось добавить <b>#{@failure[0].count}</b> #{Russian.p(@failure[0].count, 'факультет', 'факультета', 'факультетов')}, <b>#{@failure[1].count}</b> #{Russian.p(@failure[1].count, 'кафедра', 'кафедры', 'кафедр')}" if @failure.any?
      else
        redirect_to({:action => :import}, :notice => 'Надо указать файл')
      end
    end
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}_faculties"
  end

  def get_all_faculties
    @faculties = Faculty.all(:conditions => {:college_id => params[:college_id]}, :order => :name)
  end
end
