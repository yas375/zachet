# -*- coding: utf-8 -*-
class Admin::DisciplinesController < Admin::AdminController
  before_filter :find_college, :set_current_navigation

  # TODO: needs some refactor. use @college before getting disciplines
  def index
    @disciplines = Discipline.paginate(:include => :college, :conditions => {:college_id => params[:college_id]}, :order => :name, :page => params[:page])
  end

  def new
    @discipline = Discipline.new
  end

  def create
    @discipline = Discipline.new(params[:discipline])
    @discipline.college = @college
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
    if @discipline.update_attributes(params[:discipline].merge(:college => @college))
      flash[:notice] = "Предмет обновлён"
      redirect_to :action => :index
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

  def import
    if params[:disciplines] && params[:disciplines][:file] && params[:disciplines][:file].is_a?(Tempfile)
      @success, @failure = [], []
      params[:disciplines][:file].readlines.each do |line|
        name, abbr = line.split('*').collect(&:strip)
        d = Discipline.new(:name => name, :abbr => abbr, :college => @college)
        if d.save
          @success << d
        else
          @failure << d
        end
      end
      flash.now[:notice] = "Добавлено <b>#{@success.count}</b> #{Russian.p(@success.count, 'предмет', 'предмета', 'предметов')}" if @success.any?
      flash.now[:error] = "Неудалось добавить <b>#{@failure.count}</b> #{Russian.p(@failure.count, 'предмет', 'предмета', 'предметов')}" if @failure.any?
    else
      redirect_to({:action => :new}, :notice => 'Надо указать файл')
    end
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}_disciplines"
  end
end
