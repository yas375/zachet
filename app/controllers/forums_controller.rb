# -*- coding: utf-8 -*-
class ForumsController < ApplicationController
  layout 'forum'
  before_filter :find_forum, :only => [:show, :edit, :update, :destroy, :move_up, :move_down]

  def index
    @forums = Forum
    @topic_counter = Topic.all.count
    @posts_counter = Post.all.count
    @users_counter = User.active.count
    @last_user = User.active.last(:order => 'created_at')
  end

  def show
    @descendants = Forum.all(:conditions => ['parent_id = ?', params[:id]], :order => 'lft')
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
  end

  def update
    if @forum.update_attributes(params[:forum].slice!(:author_id))
      flash[:notice] = "Форум успешно обновлён"
      redirect_to @forum
    else
      render :action => 'edit'
    end
  end

  def destroy
    @forum.destroy
    flash[:notice] = "Форум успешно удалён"
    redirect_to :back
  end

  def move_up
    @forum.move_left if @forum.left_sibling
    redirect_to :back
  end

  def move_down
    @forum.move_right if @forum.right_sibling
    redirect_to :back
  end

  private

  def find_forum
    @forum = Forum.find(params[:id])
  end
end
