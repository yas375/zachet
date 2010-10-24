# -*- coding: utf-8 -*-
class TopicsController < ApplicationController
  layout 'forum'
  before_filter :find_topic, :only => [:show, :edit, :update, :destroy]
  before_filter :find_forum, :only => [:new, :create]

  def show
    @posts = @topic.posts.all(:order => 'created_at', :include => :author)
    @new_post = @topic.posts.new
  end

  def new
    if @forum.level <= 1
      flash[:error] = 'Нельзя создавать темы в верхних форумах. Выберите какой-нибудь из дочерних форумов.'
      redirect_to root_path
    end
    @topic = Topic.new(:forum => @forum)
    @post = @topic.posts.build
  end

  def create
    @topic = @forum.topics.build(params[:topic].merge(:author => current_user))
    @post = @topic.posts.build(params[:post].merge(:author => current_user))

    if @topic.save
      flash[:notice] = "Тема создана"
      redirect_to @topic
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @topic.update_attributes(params[:topic].slice!(:author_id))
      flash[:notice] = "Тема обновлена"
      redirect_to @topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    @forum = @topic.forum
    @topic.destroy
    flash[:notice] = "Тема и все её сообщения удалены"
    redirect_to forum_path(@forum)
  end

  private

  def find_forum
    @forum = Forum.find(params[:forum_id])
  end

  def find_topic
    @topic = Topic.find(params[:id])
  end
end
