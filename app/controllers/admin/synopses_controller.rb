# -*- coding: utf-8 -*-
class Admin::SynopsesController < Admin::AdminController
  before_filter :set_current_navigation
  before_filter :find_college
  before_filter :find_disciplines, :only => [:new, :edit]
  before_filter :find_synopsis, :only => [:edit, :update, :destroy]

  def index
    @synopses = Content::Synopsis.find_by_college(@college)
  end

  def new
    @synopsis = Content::Synopsis.new
  end

  def edit
  end

  def create
    @synopsis = Content::Synopsis.new(params[:content_synopsis].merge(:author => current_user))

    respond_to do |format|
      if @synopsis.save
        flash[:notice] = 'Конспект успешно добавлен'
        format.html { redirect_to admin_college_synopses_path(@college) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @synopsis.update_attributes(params[:content_synopsis])
        flash[:notice] = 'Конспект обновлён'
        format.html { redirect_to admin_college_synopses_path(@college) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @synopsis.destroy

    respond_to do |format|
      format.html { redirect_to(admin_college_synopses_path(@college)) }
    end
  end

  private

  def set_current_navigation
    current_navigation :"college_#{params[:college_id]}_synopses"
  end

  def find_college
    @college = College.find(params[:college_id])
  end

  def find_disciplines
    @disciplines = @college.disciplines
  end

  def find_synopsis
    @synopsis = Content::Synopsis.find_by_college(@college).find(params[:id])
  end
end
