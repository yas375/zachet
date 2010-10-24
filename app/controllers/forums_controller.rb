# -*- coding: utf-8 -*-
class ForumsController < ApplicationController
  layout 'forum'

  def index
    @forums = Forum
  end

  def show
    @forum = Forum.find(params[:id])
    @descendants = Forum.all(:conditions => ['parent_id = ?', params[:id]])
    @topics = @forum.topics.all(:order => 'updated_at DESC')
  end

  def new
    @forum = Forum.new
    if @parent = Forum.id_eq(params[:parent_id]).first
      @forum.parent = @parent
    end
  end

  def create
    @forum = Forum.new(params[:forum])
    if @forum.save
      flash[:notice] = "Форум успешно создан"
      redirect_to @forum
    else
      render :action => 'new'
    end
  end

  def edit
    @forum = Forum.find(params[:id])
  end

  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum].slice!(:author_id))
      flash[:notice] = "Форум успешно обновлён"
      redirect_to @forum
    else
      render :action => 'edit'
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    flash[:notice] = "Форум успешно удалён"
    redirect_to root_path
  end
end