# -*- coding: utf-8 -*-
class TopicsController < ApplicationController
  layout 'forum'

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.all(:order => 'created_at')
    @new_post = @topic.posts.new
  end

  def new
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.new(:forum => @forum)
    @post = @topic.posts.build
  end

  def create
    @forum = Forum.find(params[:forum_id])
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
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic].slice!(:author_id))
      flash[:notice] = "Тема обновлена"
      redirect_to @topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @forum = @topic.forum
    @topic.destroy
    flash[:notice] = "Тема и все ей сообщения удалены"
    redirect_to forum_path(@forum)
  end
end
